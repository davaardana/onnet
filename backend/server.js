const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const passport = require('./config/passport');
const authRoutes = require('./routes/auth');
const locationRoutes = require('./routes/locations');
const orderRoutes = require('./routes/orders');
const adminRoutes = require('./routes/admin');
const initDatabase = require('./config/initDb');

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(passport.initialize());

// Initialize database on startup
initDatabase().then(() => {
  console.log('Database initialized');
}).catch(err => {
  console.error('Database initialization failed:', err);
});

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/locations', locationRoutes);
app.use('/api/orders', orderRoutes);
app.use('/api/admin', adminRoutes);

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', message: 'Netpoint API is running' });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ 
    error: 'Something went wrong!',
    message: err.message 
  });
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
