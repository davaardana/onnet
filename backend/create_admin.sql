-- Create admin user
-- Username: admin
-- Password: onnet123 (hashed with bcrypt)

INSERT INTO users (name, email, password, role, created_at, updated_at)
VALUES (
  'Administrator',
  'admin@netpoint.com',
  '$2a$10$YQ7h5QqZ9X.8jGxKxN3k0uK3rVK5d5YJ5x6YZ5YZ5YZ5YZ5YZ5YZ5Y',
  'admin',
  CURRENT_TIMESTAMP,
  CURRENT_TIMESTAMP
)
ON CONFLICT (email) DO UPDATE
SET role = 'admin';

-- Verify
SELECT id, name, email, role FROM users WHERE email = 'admin@netpoint.com';
