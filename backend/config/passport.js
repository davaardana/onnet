const passport = require('passport');
const db = require('../config/database');

const hasValidGoogleConfig = Boolean(
  process.env.GOOGLE_CLIENT_ID &&
  process.env.GOOGLE_CLIENT_SECRET &&
  !process.env.GOOGLE_CLIENT_ID.includes('your_google_client_id')
);

if (hasValidGoogleConfig) {
  try {
    const GoogleStrategy = require('passport-google-oauth20').Strategy;
    passport.use(
      new GoogleStrategy(
        {
          clientID: process.env.GOOGLE_CLIENT_ID,
          clientSecret: process.env.GOOGLE_CLIENT_SECRET,
          callbackURL:
            process.env.GOOGLE_CALLBACK_URL ||
            'https://api.netpoint.id/api/auth/google/callback',
        },
        async (accessToken, refreshToken, profile, done) => {
          try {
            const email = profile.emails?.[0]?.value;
            if (!email) {
              return done(new Error('No email found in Google profile'), null);
            }

            const result = await db.query(
              'SELECT * FROM users WHERE google_id = $1 OR email = $2',
              [profile.id, email]
            );

            if (result.rows.length > 0) {
              const user = result.rows[0];
              if (!user.google_id) {
                await db.query(
                  'UPDATE users SET google_id = $1 WHERE id = $2',
                  [profile.id, user.id]
                );
              }
              return done(null, user);
            }

            const newUser = await db.query(
              `INSERT INTO users (name, email, google_id, role)
               VALUES ($1, $2, $3, $4)
               RETURNING *`,
              [profile.displayName || 'Google User', email, profile.id, 'user']
            );

            return done(null, newUser.rows[0]);
          } catch (error) {
            console.error('Google OAuth Error:', error);
            return done(error, null);
          }
        }
      )
    );
  } catch (err) {
    console.warn('GoogleStrategy initialization warning:', err.message);
  }
}

passport.serializeUser((user, done) => {
  done(null, user.id);
});

passport.deserializeUser(async (id, done) => {
  try {
    const result = await db.query('SELECT * FROM users WHERE id = $1', [id]);
    done(null, result.rows[0]);
  } catch (error) {
    done(error, null);
  }
});

module.exports = {
  passport,
  isGoogleConfigured: () => hasValidGoogleConfig,
};
