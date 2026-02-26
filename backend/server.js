const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const rateLimit = require('express-rate-limit');
const compression = require('compression');
const authRoutes = require('./routes/auth');
const locationRoutes = require('./routes/locations');
const orderRoutes = require('./routes/orders');
const adminRoutes = require('./routes/admin');
const pricingRoutes = require('./routes/pricing');
const buildingRoutes = require('./routes/buildings');
const initDatabase = require('./config/initDb');

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

// Trust proxy - required for rate limiting behind Nginx
app.set('trust proxy', 1);

// Enable compression for all responses
app.use(compression());

// Enable ETag for caching
app.set('etag', 'strong');

// Rate limiting middleware
const generalLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Limit each IP to 100 requests per windowMs
  message: 'Too many requests from this IP, please try again later.',
  standardHeaders: true,
  legacyHeaders: false,
});

const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 20, // Limit each IP to 20 login/register/refresh attempts per windowMs
  message: { error: 'Too many authentication attempts. Please try again in 15 minutes.' },
  skipSuccessfulRequests: true,
  standardHeaders: true,
  legacyHeaders: false,
});

// Lighter limiter for logout & /me — no brute-force risk, just prevent abuse
const lightAuthLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 200,
  standardHeaders: true,
  legacyHeaders: false,
});

// CORS Configuration
const corsOptions = {
  origin: process.env.CORS_ORIGIN || 'https://netpoint.id',
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  optionsSuccessStatus: 200
};

// Middleware
app.use(cors(corsOptions));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use('/api/', generalLimiter);

// Initialize database on startup
initDatabase().then(() => {
  console.log('Database initialized');
}).catch(err => {
  console.error('Database initialization failed:', err);
});

// Routes — apply strict limiter only to credential-based endpoints
app.use('/api/auth/login', authLimiter);
app.use('/api/auth/register', authLimiter);
app.use('/api/auth/refresh', authLimiter);
app.use('/api/auth', lightAuthLimiter, authRoutes);
app.use('/api/locations', locationRoutes);
app.use('/api/orders', orderRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/pricing', pricingRoutes);
app.use('/api', buildingRoutes);

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', message: 'Netpoint API is running' });
});

// 404 handler for unknown routes
app.use((req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

// Error handling middleware — never expose internal errors in production
app.use((err, req, res, next) => {
  console.error(err.stack);
  const isProd = process.env.NODE_ENV === 'production';
  res.status(err.status || 500).json({
    error: isProd ? 'Something went wrong!' : (err.message || 'Internal Server Error')
  });
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
