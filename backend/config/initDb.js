const db = require('../config/database');
const bcrypt = require('bcryptjs');

// Initialize database tables
const initDatabase = async () => {
  try {
    // Users table
    await db.query(`
      CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        email VARCHAR(255) UNIQUE NOT NULL,
        phone VARCHAR(50),
        password VARCHAR(255),
        google_id VARCHAR(255),
        role VARCHAR(20) DEFAULT 'user',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);

    // Locations table
    await db.query(`
      CREATE TABLE IF NOT EXISTS locations (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        address TEXT NOT NULL,
        city VARCHAR(100) NOT NULL,
        province VARCHAR(100) NOT NULL,
        is_onnet BOOLEAN DEFAULT true,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);

    // Pricing tiers table
    await db.query(`
      CREATE TABLE IF NOT EXISTS pricing_tiers (
        id SERIAL PRIMARY KEY,
        tier_name VARCHAR(100) NOT NULL,
        capacity VARCHAR(50) NOT NULL,
        sla VARCHAR(20) NOT NULL,
        setup_time VARCHAR(50) NOT NULL,
        monthly_price INTEGER,
        features TEXT[],
        is_popular BOOLEAN DEFAULT false,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);

    // Orders table
    await db.query(`
      CREATE TABLE IF NOT EXISTS orders (
        id SERIAL PRIMARY KEY,
        user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
        location_id INTEGER REFERENCES locations(id) ON DELETE SET NULL,
        tier_id INTEGER REFERENCES pricing_tiers(id) ON DELETE SET NULL,
        location_name VARCHAR(255) NOT NULL,
        status VARCHAR(50) DEFAULT 'pending',
        notes TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);

    console.log('Database tables initialized successfully');

    // Insert default pricing tiers if not exist
    const tiersCount = await db.query('SELECT COUNT(*) FROM pricing_tiers');
    if (tiersCount.rows[0].count === '0') {
      await db.query(`
        INSERT INTO pricing_tiers (tier_name, capacity, sla, setup_time, monthly_price, features, is_popular)
        VALUES 
        ('Netpoint Basic', '50 Mbps', '99.0%', '7 Hari', 1500000, 
         ARRAY['Bandwidth up to 50 Mbps', 'SLA 99.0%', 'Email Support', 'Setup dalam 7 hari kerja'], 
         false),
        ('Netpoint Business', '100 Mbps', '99.7%', '5 Hari', 3000000,
         ARRAY['Bandwidth up to 100 Mbps', 'SLA 99.7%', '24/7 Phone Support', 'Setup dalam 5 hari kerja', 'Dedicated Account Manager'],
         true),
        ('Netpoint Enterprise', '1 Gbps', '99.9%', 'Custom', NULL,
         ARRAY['Bandwidth up to 1 Gbps', 'SLA 99.9%', '24/7 Priority Support', 'Custom Setup Timeline', 'Dedicated Technical Team', 'Custom Configuration'],
         false)
      `);
      console.log('Default pricing tiers inserted');
    }

    // Insert sample locations if not exist
    const locationsCount = await db.query('SELECT COUNT(*) FROM locations');
    if (locationsCount.rows[0].count === '0') {
      await db.query(`
        INSERT INTO locations (name, address, city, province, is_onnet)
        VALUES 
        ('Menara Sudirman', 'Jl. Jend. Sudirman Kav. 60', 'Jakarta Selatan', 'DKI Jakarta', true),
        ('Wisma BNI', 'Jl. Jend. Sudirman Kav. 1', 'Jakarta Pusat', 'DKI Jakarta', true),
        ('Gedung Mayapada Tower', 'Jl. Jend. Sudirman Kav. 28', 'Jakarta Selatan', 'DKI Jakarta', true),
        ('Cyber Building', 'Jl. Kuningan Barat No. 8', 'Jakarta Selatan', 'DKI Jakarta', true)
      `);
      console.log('Sample locations inserted');
    }

    // Create default admin user if not exists
    const adminExists = await db.query('SELECT * FROM users WHERE email = $1', ['admin@netpoint.com']);
    if (adminExists.rows.length === 0) {
      const hashedPassword = await bcrypt.hash('onnet123', 10);
      await db.query(`
        INSERT INTO users (name, email, password, role)
        VALUES ($1, $2, $3, $4)
      `, ['admin', 'admin@netpoint.com', hashedPassword, 'admin']);
      console.log('✅ Default admin user created');
      console.log('   Username: admin');
      console.log('   Email: admin@netpoint.com');
      console.log('   Password: onnet123');
    }

  } catch (error) {
    console.error('Error initializing database:', error);
    throw error;
  }
};

module.exports = initDatabase;
