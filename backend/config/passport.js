const passport = require('passport');
const GoogleStrategy = require('passport-google-oauth20').Strategy;
const db = require('../config/database');

// Configure Google OAuth Strategy
passport.use(
  new GoogleStrategy(
    {
      clientID: process.env.GOOGLE_CLIENT_ID,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET,
      callbackURL: process.env.GOOGLE_CALLBACK_URL || 'http://localhost:5000/api/auth/google/callback',
    },
    async (accessToken, refreshToken, profile, done) => {
      try {
        // Check if user already exists
        const result = await db.query(
          'SELECT * FROM users WHERE google_id = $1 OR email = $2',
          [profile.id, profile.emails[0].value]
        );

        if (result.rows.length > 0) {
          // User exists, update google_id if not set
          const user = result.rows[0];
          if (!user.google_id) {
            await db.query(
              'UPDATE users SET google_id = $1 WHERE id = $2',
              [profile.id, user.id]
            );
          }
          return done(null, user);
        }

        // Create new user
        const newUser = await db.query(
          `INSERT INTO users (name, email, google_id, role) 
           VALUES ($1, $2, $3, $4) 
           RETURNING *`,
          [
            profile.displayName,
            profile.emails[0].value,
            profile.id,
            'user'
          ]
        );

        return done(null, newUser.rows[0]);
      } catch (error) {
        console.error('Google OAuth Error:', error);
        return done(error, null);
      }
    }
  )
);

// Serialize user for session
passport.serializeUser((user, done) => {
  done(null, user.id);
});

// Deserialize user from session
passport.deserializeUser(async (id, done) => {
  try {
    const result = await db.query('SELECT * FROM users WHERE id = $1', [id]);
    done(null, result.rows[0]);
  } catch (error) {
    done(error, null);
  }
});

module.exports = passport;
