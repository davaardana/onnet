const express = require('express');
const router = express.Router();
const { authMiddleware } = require('../middleware/auth');
const db = require('../config/database');

// Middleware to check if user is admin
const isAdmin = async (req, res, next) => {
  try {
    const result = await db.query(
      'SELECT role FROM users WHERE id = $1',
      [req.user.userId]
    );

    if (result.rows.length === 0 || result.rows[0].role !== 'admin') {
      return res.status(403).json({ error: 'Access denied. Admin only.' });
    }

    next();
  } catch (error) {
    console.error('Admin check error:', error);
    res.status(500).json({ error: 'Server error' });
  }
};

// Get dashboard statistics
router.get('/stats', authMiddleware, isAdmin, async (req, res) => {
  try {
    // Total users
    const usersResult = await db.query('SELECT COUNT(*) as count FROM users');
    const totalUsers = parseInt(usersResult.rows[0].count);

    // Total external (non-admin) users
    const extResult = await db.query("SELECT COUNT(*) as count FROM users WHERE role <> 'admin'");
    const totalExternalUsers = parseInt(extResult.rows[0].count);

    // Total orders
    const ordersResult = await db.query('SELECT COUNT(*) as count FROM orders');
    const totalOrders = parseInt(ordersResult.rows[0].count);

    // Total buildings
    const buildingsResult = await db.query('SELECT COUNT(*) as count FROM buildings');
    const totalBuildings = parseInt(buildingsResult.rows[0].count);

    // Price book rows
    const priceResult = await db.query('SELECT COUNT(*) as count FROM price_list WHERE status = $1', ['active']);
    const totalPriceRows = parseInt(priceResult.rows[0].count);

    // Orders by status
    const statusResult = await db.query(`
      SELECT status, COUNT(*) as count 
      FROM orders 
      GROUP BY status
    `);
    const ordersByStatus = statusResult.rows.reduce((acc, row) => {
      acc[row.status] = parseInt(row.count);
      return acc;
    }, {});

    // Total revenue (completed orders only)
    const revenueResult = await db.query(`
      SELECT 
        COALESCE(SUM(pt.monthly_price), 0) as total_revenue
      FROM orders o
      JOIN pricing_tiers pt ON o.tier_id = pt.id
      WHERE o.status = 'completed'
    `);
    const totalRevenue = parseInt(revenueResult.rows[0].total_revenue || 0);

    // Monthly revenue (last 6 months)
    const monthlyRevenueResult = await db.query(`
      SELECT 
        DATE_TRUNC('month', o.created_at) as month,
        SUM(pt.monthly_price) as revenue
      FROM orders o
      JOIN pricing_tiers pt ON o.tier_id = pt.id
      WHERE o.status = 'completed'
        AND o.created_at >= NOW() - INTERVAL '6 months'
      GROUP BY DATE_TRUNC('month', o.created_at)
      ORDER BY month DESC
    `);
    const monthlyRevenue = monthlyRevenueResult.rows;

    // Recent orders
    const recentOrdersResult = await db.query(`
      SELECT 
        o.id,
        o.status,
        o.created_at,
        o.bandwidth_mbps,
        o.service_type,
        o.zone,
        o.source,
        o.whatsapp_number,
        u.name as user_name,
        u.email as user_email,
        COALESCE(l.name, o.location_name) as location_name,
        pt.tier_name,
        pt.monthly_price
      FROM orders o
      LEFT JOIN users u ON o.user_id = u.id
      LEFT JOIN locations l ON o.location_id = l.id
      LEFT JOIN pricing_tiers pt ON o.tier_id = pt.id
      ORDER BY o.created_at DESC
      LIMIT 10
    `);
    const recentOrders = recentOrdersResult.rows;

    // Top locations
    const topLocationsResult = await db.query(`
      SELECT 
        l.name,
        l.city,
        COUNT(o.id) as order_count
      FROM locations l
      LEFT JOIN orders o ON l.id = o.location_id
      GROUP BY l.id, l.name, l.city
      ORDER BY order_count DESC
      LIMIT 10
    `);
    const topLocations = topLocationsResult.rows;

    // Quote logs (latest 10)
    const quoteLogsResult = await db.query(`
      SELECT ql.*, u.name AS user_name, u.email AS user_email
      FROM quote_logs ql
      LEFT JOIN users u ON ql.user_id = u.id
      ORDER BY ql.created_at DESC
      LIMIT 10
    `);

    res.json({
      totalUsers,
      totalExternalUsers,
      totalOrders,
      totalBuildings,
      totalPriceRows,
      totalRevenue,
      ordersByStatus,
      monthlyRevenue,
      recentOrders,
      topLocations,
      quoteLogs: quoteLogsResult.rows
    });
  } catch (error) {
    console.error('Get stats error:', error);
    res.status(500).json({ error: 'Failed to fetch statistics' });
  }
});

// Admin data explorer: returns paged datasets for FE tables
router.get('/datasets', authMiddleware, isAdmin, async (req, res) => {
  try {
    const limit = parseInt(req.query.limit) || 50;
    const offset = parseInt(req.query.offset) || 0;
    const q = (req.query.q || '').trim();

    const buildingParams = [];
    let buildingWhere = '';
    if (q) {
      buildingParams.push(`%${q}%`);
      buildingWhere = `WHERE building_name ILIKE $1 OR address ILIKE $1 OR city ILIKE $1 OR zone ILIKE $1`;
    }

    const buildingsQuery = `
      SELECT id, building_name, address, city, zone, country, status
      FROM buildings
      ${buildingWhere}
      ORDER BY building_name
      LIMIT $${buildingParams.length + 1} OFFSET $${buildingParams.length + 2}
    `;

    const buildings = await db.query(
      buildingsQuery,
      [...buildingParams, limit, offset]
    );

    const buildingsTotalResult = await db.query(
      `SELECT COUNT(*) as count FROM buildings ${buildingWhere}`,
      buildingParams
    );

    const priceList = await db.query(
      `SELECT id, bandwidth_mbps,
              domestic_otc, domestic_mrc_zone1, domestic_mrc_zone2, domestic_mrc_zone3, domestic_mrc_zone4,
              intl_otc, intl_mrc_zone1, intl_mrc_zone2, intl_mrc_zone3, intl_mrc_zone4,
              dia_otc, dia_mrc,
              idia_otc, idia_mrc,
              year, status
         FROM price_list
         WHERE status = 'active'
         ORDER BY bandwidth_mbps`
    );

    const priceListTotalResult = await db.query(
      `SELECT COUNT(*) as count FROM price_list WHERE status = 'active'`
    );

    const quoteLogs = await db.query(
      `SELECT ql.*, u.name AS user_name, u.email AS user_email
         FROM quote_logs ql
         LEFT JOIN users u ON ql.user_id = u.id
         ORDER BY ql.created_at DESC
         LIMIT $1 OFFSET $2`,
      [limit, offset]
    );

    const quoteLogsTotalResult = await db.query(
      `SELECT COUNT(*) as count FROM quote_logs`
    );

    const usersExternal = await db.query(
      `SELECT id, name, email, phone, role, created_at
         FROM users
        WHERE role <> 'admin'
        ORDER BY created_at DESC
        LIMIT $1 OFFSET $2`,
      [limit, offset]
    );

    const usersExternalTotalResult = await db.query(
      `SELECT COUNT(*) as count FROM users WHERE role <> 'admin'`
    );

    res.json({
      buildings: buildings.rows,
      buildingsTotal: parseInt(buildingsTotalResult.rows[0].count, 10),
      priceList: priceList.rows,
      priceListTotal: parseInt(priceListTotalResult.rows[0].count, 10),
      quoteLogs: quoteLogs.rows,
      quoteLogsTotal: parseInt(quoteLogsTotalResult.rows[0].count, 10),
      usersExternal: usersExternal.rows,
      usersExternalTotal: parseInt(usersExternalTotalResult.rows[0].count, 10),
      limit,
      offset,
      q
    });
  } catch (error) {
    console.error('Get datasets error:', error);
    res.status(500).json({ error: 'Failed to fetch datasets' });
  }
});

// Get all users
router.get('/users', authMiddleware, isAdmin, async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 20;
    const offset = (page - 1) * limit;

    const result = await db.query(`
      SELECT 
        id, name, email, phone, role, google_id, created_at
      FROM users
      ORDER BY created_at DESC
      LIMIT $1 OFFSET $2
    `, [limit, offset]);

    const countResult = await db.query('SELECT COUNT(*) as count FROM users');
    const total = parseInt(countResult.rows[0].count);

    res.json({
      users: result.rows,
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit)
      }
    });
  } catch (error) {
    console.error('Get users error:', error);
    res.status(500).json({ error: 'Failed to fetch users' });
  }
});

// Get all orders (admin view)
router.get('/orders', authMiddleware, isAdmin, async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 20;
    const offset = (page - 1) * limit;
    const status = req.query.status;

    let query = `
      SELECT 
        o.id,
        o.status,
        o.notes,
        o.created_at,
        o.updated_at,
        o.bandwidth_mbps,
        o.service_type,
        o.zone,
        o.source,
        o.whatsapp_number,
        u.name as user_name,
        u.email as user_email,
        u.phone as user_phone,
        COALESCE(l.name, o.location_name) as location_name,
        COALESCE(l.address, o.location_name) as location_address,
        l.city as location_city,
        pt.tier_name,
        pt.capacity,
        pt.monthly_price
      FROM orders o
      LEFT JOIN users u ON o.user_id = u.id
      LEFT JOIN locations l ON o.location_id = l.id
      LEFT JOIN pricing_tiers pt ON o.tier_id = pt.id
    `;

    const params = [limit, offset];
    
    if (status) {
      query += ' WHERE o.status = $3';
      params.push(status);
    }

    query += ' ORDER BY o.created_at DESC LIMIT $1 OFFSET $2';

    const result = await db.query(query, params);

    const countQuery = status 
      ? 'SELECT COUNT(*) as count FROM orders WHERE status = $1'
      : 'SELECT COUNT(*) as count FROM orders';
    const countParams = status ? [status] : [];
    const countResult = await db.query(countQuery, countParams);
    const total = parseInt(countResult.rows[0].count);

    res.json({
      orders: result.rows,
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit)
      }
    });
  } catch (error) {
    console.error('Get orders error:', error);
    res.status(500).json({ error: 'Failed to fetch orders' });
  }
});

// Update order status (admin only)
router.put('/orders/:id/status', authMiddleware, isAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    const { status, notes } = req.body;

    const validStatuses = ['pending', 'processing', 'completed', 'cancelled'];
    if (!validStatuses.includes(status)) {
      return res.status(400).json({ error: 'Invalid status' });
    }

    const result = await db.query(
      `UPDATE orders 
       SET status = $1, notes = COALESCE($2, notes), updated_at = CURRENT_TIMESTAMP
       WHERE id = $3
       RETURNING *`,
      [status, notes, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Order not found' });
    }

    res.json({
      message: 'Order updated successfully',
      order: result.rows[0]
    });
  } catch (error) {
    console.error('Update order error:', error);
    res.status(500).json({ error: 'Failed to update order' });
  }
});

// Update user role
router.put('/users/:id/role', authMiddleware, isAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    const { role } = req.body;

    const validRoles = ['user', 'admin'];
    if (!validRoles.includes(role)) {
      return res.status(400).json({ error: 'Invalid role' });
    }

    const result = await db.query(
      'UPDATE users SET role = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2 RETURNING id, name, email, role',
      [role, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json({
      message: 'User role updated successfully',
      user: result.rows[0]
    });
  } catch (error) {
    console.error('Update user role error:', error);
    res.status(500).json({ error: 'Failed to update user role' });
  }
});

module.exports = router;
