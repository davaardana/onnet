const express = require('express');
const router = express.Router();
const { body, validationResult } = require('express-validator');
const db = require('../config/database');
const authMiddleware = require('../middleware/auth');

// Get pricing tiers
router.get('/pricing', async (req, res) => {
  try {
    const result = await db.query(
      'SELECT * FROM pricing_tiers ORDER BY monthly_price ASC NULLS LAST'
    );

    res.json({
      tiers: result.rows,
      count: result.rows.length
    });
  } catch (error) {
    console.error('Get pricing error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Create order (requires authentication)
router.post('/', authMiddleware, [
  body('locationName').trim().notEmpty(),
  body('tierId').isInt(),
  body('notes').optional().trim()
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { locationName, tierId, locationId, notes } = req.body;
    const userId = req.user.userId;

    const result = await db.query(
      `INSERT INTO orders (user_id, location_id, tier_id, location_name, notes, status)
       VALUES ($1, $2, $3, $4, $5, 'pending')
       RETURNING *`,
      [userId, locationId || null, tierId, locationName, notes || null]
    );

    res.status(201).json({
      message: 'Order created successfully',
      order: result.rows[0]
    });
  } catch (error) {
    console.error('Create order error:', error);
    res.status(500).json({ error: 'Server error during order creation' });
  }
});

// Get user orders (requires authentication)
router.get('/', authMiddleware, async (req, res) => {
  try {
    const userId = req.user.userId;

    const result = await db.query(
      `SELECT o.*, pt.tier_name, pt.capacity, pt.monthly_price
       FROM orders o
       LEFT JOIN pricing_tiers pt ON o.tier_id = pt.id
       WHERE o.user_id = $1
       ORDER BY o.created_at DESC`,
      [userId]
    );

    res.json({
      orders: result.rows,
      count: result.rows.length
    });
  } catch (error) {
    console.error('Get orders error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router;
