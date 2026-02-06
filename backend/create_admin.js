const bcrypt = require('bcryptjs');
const db = require('./config/database');

async function createAdmin() {
  try {
    // Hash password "onnet123"
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash('onnet123', salt);

    // Insert admin user
    const result = await db.query(`
      INSERT INTO users (name, email, password, role, created_at, updated_at)
      VALUES ($1, $2, $3, $4, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
      ON CONFLICT (email) 
      DO UPDATE SET 
        password = EXCLUDED.password,
        role = EXCLUDED.role,
        updated_at = CURRENT_TIMESTAMP
      RETURNING id, name, email, role
    `, ['Administrator', 'admin@netpoint.com', hashedPassword, 'admin']);

    console.log('✅ Admin user created successfully!');
    console.log('📧 Email: admin@netpoint.com');
    console.log('🔑 Password: onnet123');
    console.log('👤 User:', result.rows[0]);
    
    process.exit(0);
  } catch (error) {
    console.error('❌ Error creating admin:', error);
    process.exit(1);
  }
}

createAdmin();
