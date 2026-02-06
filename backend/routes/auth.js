const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { body, validationResult } = require('express-validator');
const crypto = require('crypto');
const db = require('../config/database');
const { recordAudit } = require('../utils/audit');

const ACCESS_TOKEN_TTL = process.env.ACCESS_TOKEN_TTL || '7d';
const REFRESH_TOKEN_DAYS = parseInt(process.env.REFRESH_TOKEN_DAYS || '30', 10);

const signAccessToken = (user) => jwt.sign(
  { userId: user.id, email: user.email, role: user.role },
  process.env.JWT_SECRET,
  { expiresIn: ACCESS_TOKEN_TTL }
);

const hashToken = (token) => crypto.createHash('sha256').update(token).digest('hex');

const createRefreshToken = () => {
  const token = crypto.randomBytes(64).toString('hex');
  const tokenHash = hashToken(token);
  const expiresAt = new Date(Date.now() + REFRESH_TOKEN_DAYS * 24 * 60 * 60 * 1000);
  return { token, tokenHash, expiresAt };
};

const persistRefreshToken = async (userId, tokenHash, expiresAt, req) => {
  await db.query(
    `INSERT INTO refresh_tokens (user_id, token_hash, user_agent, ip_address, expires_at)
     VALUES ($1, $2, $3, $4, $5)`,
    [userId, tokenHash, req.headers['user-agent'] || null, req.ip || null, expiresAt]
  );
};

const rotateRefreshToken = async (currentHash, nextHash) => {
  await db.query(
    `UPDATE refresh_tokens
     SET revoked_at = NOW(), replaced_by_token_hash = $2
     WHERE token_hash = $1`,
    [currentHash, nextHash]
  );
};

// Register
router.post('/register', [
  body('email').isEmail().normalizeEmail(),
  body('password').isLength({ min: 6 }),
  body('name').trim().notEmpty(),
  body('phone').optional().trim()
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { name, email, phone, password } = req.body;

    // Check if user exists
    const userExists = await db.query(
      'SELECT * FROM users WHERE email = $1',
      [email]
    );

    if (userExists.rows.length > 0) {
      return res.status(400).json({ error: 'User already exists' });
    }

    // Hash password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Insert user with default role 'user' (NOT admin)
    const result = await db.query(
      'INSERT INTO users (name, email, phone, password, role) VALUES ($1, $2, $3, $4, $5) RETURNING id, name, email, phone, role, created_at',
      [name, email, phone, hashedPassword, 'user']
    );

    const user = result.rows[0];

    // Issue tokens
    const accessToken = signAccessToken(user);
    const { token: refreshToken, tokenHash, expiresAt } = createRefreshToken();

    await persistRefreshToken(user.id, tokenHash, expiresAt, req);
    recordAudit(user.id, 'register', 'auth', { method: 'password' }, req);

    res.status(201).json({
      message: 'User registered successfully',
      user,
      token: accessToken,
      refreshToken,
      refreshTokenExpiresAt: expiresAt.toISOString()
    });
  } catch (error) {
    console.error('Register error:', error);
    res.status(500).json({ error: 'Server error during registration' });
  }
});

// Login
router.post('/login', [
  body('identifier').trim().notEmpty(),
  body('password').notEmpty()
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { identifier, password } = req.body;

    // Find user by email or name (username)
    const result = await db.query(
      'SELECT * FROM users WHERE email = $1 OR name = $1',
      [identifier]
    );

    if (result.rows.length === 0) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const user = result.rows[0];

    // Check password
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    // Issue tokens
    const accessToken = signAccessToken(user);
    const { token: refreshToken, tokenHash, expiresAt } = createRefreshToken();

    await persistRefreshToken(user.id, tokenHash, expiresAt, req);
    recordAudit(user.id, 'login', 'auth', { method: 'password' }, req);

    res.json({
      message: 'Login successful',
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role
      },
      token: accessToken,
      refreshToken,
      refreshTokenExpiresAt: expiresAt.toISOString()
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ error: 'Server error during login' });
  }
});

// Refresh access token
router.post('/refresh', [
  body('refreshToken').notEmpty()
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { refreshToken } = req.body;
    const incomingHash = hashToken(refreshToken);

    const tokenResult = await db.query(
      `SELECT * FROM refresh_tokens 
       WHERE token_hash = $1 AND revoked_at IS NULL AND expires_at > NOW()`
      , [incomingHash]
    );

    if (tokenResult.rows.length === 0) {
      return res.status(401).json({ error: 'Invalid or expired refresh token' });
    }

    const tokenRow = tokenResult.rows[0];
    const userResult = await db.query(
      'SELECT id, name, email, phone, role FROM users WHERE id = $1',
      [tokenRow.user_id]
    );

    if (userResult.rows.length === 0) {
      return res.status(401).json({ error: 'User not found for this token' });
    }

    const user = userResult.rows[0];
    const accessToken = signAccessToken(user);
    const { token: newRefreshToken, tokenHash: newRefreshHash, expiresAt: newExpiresAt } = createRefreshToken();

    await rotateRefreshToken(incomingHash, newRefreshHash);
    await persistRefreshToken(user.id, newRefreshHash, newExpiresAt, req);
    recordAudit(user.id, 'refresh_token', 'auth', { replaced_token_id: tokenRow.id }, req);

    res.json({
      token: accessToken,
      refreshToken: newRefreshToken,
      refreshTokenExpiresAt: newExpiresAt.toISOString()
    });
  } catch (error) {
    console.error('Refresh token error:', error);
    res.status(500).json({ error: 'Server error during token refresh' });
  }
});

module.exports = router;
