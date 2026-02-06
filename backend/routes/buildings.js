const express = require('express');
const router = express.Router();
const db = require('../config/database');
const { isAuthenticated, isAdmin } = require('../middleware/auth');

// Get all buildings with search and pagination
router.get('/buildings', isAuthenticated, isAdmin, async (req, res) => {
  try {
    const { search, zone, page = 1, limit = 50 } = req.query;
    const offset = (page - 1) * limit;
    
    let query = 'SELECT * FROM buildings WHERE status = $1';
    let countQuery = 'SELECT COUNT(*) FROM buildings WHERE status = $1';
    const params = ['active'];
    let paramIndex = 2;
    
    if (search) {
      query += ` AND (building_name ILIKE $${paramIndex} OR address ILIKE $${paramIndex})`;
      countQuery += ` AND (building_name ILIKE $${paramIndex} OR address ILIKE $${paramIndex})`;
      params.push(`%${search}%`);
      paramIndex++;
    }
    
    if (zone) {
      query += ` AND zone_code = $${paramIndex}`;
      countQuery += ` AND zone_code = $${paramIndex}`;
      params.push(zone);
      paramIndex++;
    }
    
    query += ` ORDER BY building_name ASC LIMIT $${paramIndex} OFFSET $${paramIndex + 1}`;
    params.push(limit, offset);
    
    const [buildings, total] = await Promise.all([
      db.query(query, params),
      db.query(countQuery, params.slice(0, -2))
    ]);
    
    res.json({
      buildings: buildings.rows,
      pagination: {
        total: parseInt(total.rows[0].count),
        page: parseInt(page),
        limit: parseInt(limit),
        totalPages: Math.ceil(total.rows[0].count / limit)
      }
    });
  } catch (error) {
    console.error('Get buildings error:', error);
    res.status(500).json({ error: 'Failed to fetch buildings' });
  }
});

// Get single building
router.get('/buildings/:id', isAuthenticated, isAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query('SELECT * FROM buildings WHERE id = $1', [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Building not found' });
    }
    
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Get building error:', error);
    res.status(500).json({ error: 'Failed to fetch building' });
  }
});

// Create building
router.post('/buildings', isAuthenticated, isAdmin, async (req, res) => {
  try {
    const { building_name, address, zone_code, zone_name, zone_number, zone_details } = req.body;
    
    const result = await db.query(
      `INSERT INTO buildings (building_name, address, zone_code, zone_name, zone_number, zone_details) 
       VALUES ($1, $2, $3, $4, $5, $6) 
       RETURNING *`,
      [building_name, address, zone_code, zone_name, zone_number, zone_details]
    );
    
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Create building error:', error);
    res.status(500).json({ error: 'Failed to create building' });
  }
});

// Update building
router.put('/buildings/:id', isAuthenticated, isAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    const { building_name, address, zone_code, zone_name, zone_number, zone_details, status } = req.body;
    
    const result = await db.query(
      `UPDATE buildings 
       SET building_name = $1, address = $2, zone_code = $3, zone_name = $4, 
           zone_number = $5, zone_details = $6, status = $7
       WHERE id = $8 
       RETURNING *`,
      [building_name, address, zone_code, zone_name, zone_number, zone_details, status, id]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Building not found' });
    }
    
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Update building error:', error);
    res.status(500).json({ error: 'Failed to update building' });
  }
});

// Delete building (soft delete)
router.delete('/buildings/:id', isAuthenticated, isAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    
    const result = await db.query(
      'UPDATE buildings SET status = $1 WHERE id = $2 RETURNING *',
      ['deleted', id]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Building not found' });
    }
    
    res.json({ message: 'Building deleted successfully' });
  } catch (error) {
    console.error('Delete building error:', error);
    res.status(500).json({ error: 'Failed to delete building' });
  }
});

// Bulk import buildings
router.post('/buildings/bulk', isAuthenticated, isAdmin, async (req, res) => {
  try {
    const { buildings } = req.body;
    
    if (!Array.isArray(buildings) || buildings.length === 0) {
      return res.status(400).json({ error: 'Buildings array is required' });
    }
    
    const values = buildings.map((b, i) => {
      const base = i * 6;
      return `($${base + 1}, $${base + 2}, $${base + 3}, $${base + 4}, $${base + 5}, $${base + 6})`;
    }).join(',');
    
    const params = buildings.flatMap(b => [
      b.building_name,
      b.address,
      b.zone_code || null,
      b.zone_name || null,
      b.zone_number || null,
      b.zone_details || null
    ]);
    
    const query = `
      INSERT INTO buildings (building_name, address, zone_code, zone_name, zone_number, zone_details)
      VALUES ${values}
      ON CONFLICT DO NOTHING
    `;
    
    await db.query(query, params);
    
    res.json({ message: `Successfully imported ${buildings.length} buildings` });
  } catch (error) {
    console.error('Bulk import error:', error);
    res.status(500).json({ error: 'Failed to import buildings' });
  }
});

// Get price list
router.get('/pricing', isAuthenticated, isAdmin, async (req, res) => {
  try {
    const { year = 2026 } = req.query;
    
    const result = await db.query(
      'SELECT * FROM price_list WHERE year = $1 AND status = $2 ORDER BY bandwidth_mbps ASC',
      [year, 'active']
    );
    
    res.json(result.rows);
  } catch (error) {
    console.error('Get pricing error:', error);
    res.status(500).json({ error: 'Failed to fetch pricing' });
  }
});

// Get price for specific bandwidth
router.get('/pricing/:bandwidth', isAuthenticated, isAdmin, async (req, res) => {
  try {
    const { bandwidth } = req.params;
    const { year = 2026 } = req.query;
    
    const result = await db.query(
      'SELECT * FROM price_list WHERE bandwidth_mbps = $1 AND year = $2 AND status = $3',
      [bandwidth, year, 'active']
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Price not found' });
    }
    
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Get price error:', error);
    res.status(500).json({ error: 'Failed to fetch price' });
  }
});

// Create/Update price
router.post('/pricing', isAuthenticated, isAdmin, async (req, res) => {
  try {
    const price = req.body;
    
    const result = await db.query(
      `INSERT INTO price_list (
        bandwidth_mbps, domestic_otc, domestic_mrc_zone1, domestic_mrc_zone2, 
        domestic_mrc_zone3, domestic_mrc_zone4, intl_otc, intl_mrc_zone1, 
        intl_mrc_zone2, intl_mrc_zone3, intl_mrc_zone4, dia_otc, dia_mrc,
        idia_bw, idia_otc, idia_mrc, year
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17)
      ON CONFLICT (bandwidth_mbps, year) 
      DO UPDATE SET
        domestic_otc = EXCLUDED.domestic_otc,
        domestic_mrc_zone1 = EXCLUDED.domestic_mrc_zone1,
        domestic_mrc_zone2 = EXCLUDED.domestic_mrc_zone2,
        domestic_mrc_zone3 = EXCLUDED.domestic_mrc_zone3,
        domestic_mrc_zone4 = EXCLUDED.domestic_mrc_zone4,
        intl_otc = EXCLUDED.intl_otc,
        intl_mrc_zone1 = EXCLUDED.intl_mrc_zone1,
        intl_mrc_zone2 = EXCLUDED.intl_mrc_zone2,
        intl_mrc_zone3 = EXCLUDED.intl_mrc_zone3,
        intl_mrc_zone4 = EXCLUDED.intl_mrc_zone4,
        dia_otc = EXCLUDED.dia_otc,
        dia_mrc = EXCLUDED.dia_mrc,
        idia_bw = EXCLUDED.idia_bw,
        idia_otc = EXCLUDED.idia_otc,
        idia_mrc = EXCLUDED.idia_mrc
      RETURNING *`,
      [
        price.bandwidth_mbps, price.domestic_otc, price.domestic_mrc_zone1,
        price.domestic_mrc_zone2, price.domestic_mrc_zone3, price.domestic_mrc_zone4,
        price.intl_otc, price.intl_mrc_zone1, price.intl_mrc_zone2,
        price.intl_mrc_zone3, price.intl_mrc_zone4, price.dia_otc,
        price.dia_mrc, price.idia_bw, price.idia_otc, price.idia_mrc,
        price.year || 2026
      ]
    );
    
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Create/update price error:', error);
    res.status(500).json({ error: 'Failed to save price' });
  }
});

// Bulk import pricing
router.post('/pricing/bulk', isAuthenticated, isAdmin, async (req, res) => {
  try {
    const { prices } = req.body;
    
    if (!Array.isArray(prices) || prices.length === 0) {
      return res.status(400).json({ error: 'Prices array is required' });
    }
    
    for (const price of prices) {
      await db.query(
        `INSERT INTO price_list (
          bandwidth_mbps, domestic_otc, domestic_mrc_zone1, domestic_mrc_zone2, 
          domestic_mrc_zone3, domestic_mrc_zone4, intl_otc, intl_mrc_zone1, 
          intl_mrc_zone2, intl_mrc_zone3, intl_mrc_zone4, dia_otc, dia_mrc,
          idia_bw, idia_otc, idia_mrc, year
        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17)
        ON CONFLICT (bandwidth_mbps, year) DO NOTHING`,
        [
          price.bandwidth_mbps, price.domestic_otc, price.domestic_mrc_zone1,
          price.domestic_mrc_zone2, price.domestic_mrc_zone3, price.domestic_mrc_zone4,
          price.intl_otc, price.intl_mrc_zone1, price.intl_mrc_zone2,
          price.intl_mrc_zone3, price.intl_mrc_zone4, price.dia_otc,
          price.dia_mrc, price.idia_bw, price.idia_otc, price.idia_mrc,
          price.year || 2026
        ]
      );
    }
    
    res.json({ message: `Successfully imported ${prices.length} prices` });
  } catch (error) {
    console.error('Bulk import pricing error:', error);
    res.status(500).json({ error: 'Failed to import prices' });
  }
});

// Calculate quote
router.post('/quote/calculate', isAuthenticated, isAdmin, async (req, res) => {
  try {
    const { building_id, bandwidth_mbps, service_type, year = 2026 } = req.body;
    
    // Get building details
    const building = await db.query('SELECT * FROM buildings WHERE id = $1', [building_id]);
    if (building.rows.length === 0) {
      return res.status(404).json({ error: 'Building not found' });
    }
    
    // Get pricing
    const pricing = await db.query(
      'SELECT * FROM price_list WHERE bandwidth_mbps = $1 AND year = $2',
      [bandwidth_mbps, year]
    );
    if (pricing.rows.length === 0) {
      return res.status(404).json({ error: 'Price not found for this bandwidth' });
    }
    
    const buildingData = building.rows[0];
    const priceData = pricing.rows[0];
    const zone = buildingData.zone_number || 1;
    
    let otc = 0;
    let mrc = 0;
    
    // Calculate based on service type and zone
    if (service_type === 'domestic') {
      otc = parseFloat(priceData.domestic_otc || 0);
      if (zone === 1) mrc = parseFloat(priceData.domestic_mrc_zone1 || 0);
      else if (zone === 2) mrc = parseFloat(priceData.domestic_mrc_zone2 || 0);
      else if (zone === 3) mrc = parseFloat(priceData.domestic_mrc_zone3 || 0);
      else if (zone === 4) mrc = parseFloat(priceData.domestic_mrc_zone4 || 0);
    } else if (service_type === 'international') {
      otc = parseFloat(priceData.intl_otc || 0);
      if (zone === 1) mrc = parseFloat(priceData.intl_mrc_zone1 || 0);
      else if (zone === 2) mrc = parseFloat(priceData.intl_mrc_zone2 || 0);
      else if (zone === 3) mrc = parseFloat(priceData.intl_mrc_zone3 || 0);
      else if (zone === 4) mrc = parseFloat(priceData.intl_mrc_zone4 || 0);
    } else if (service_type === 'dia') {
      otc = parseFloat(priceData.dia_otc || 0);
      mrc = parseFloat(priceData.dia_mrc || 0);
    } else if (service_type === 'idia') {
      otc = parseFloat(priceData.idia_otc || 0);
      mrc = parseFloat(priceData.idia_mrc || 0);
    }
    
    res.json({
      building: buildingData,
      bandwidth_mbps,
      service_type,
      zone,
      otc,
      mrc,
      total_first_month: otc + mrc,
      monthly_recurring: mrc,
      annual_cost: mrc * 12
    });
  } catch (error) {
    console.error('Calculate quote error:', error);
    res.status(500).json({ error: 'Failed to calculate quote' });
  }
});

// Create quote
router.post('/quotes', isAuthenticated, isAdmin, async (req, res) => {
  try {
    const {
      building_id, bandwidth_mbps, service_type, zone,
      otc, mrc, customer_name, customer_email, customer_phone, notes
    } = req.body;
    
    // Generate quote number
    const quoteNumber = `QT-${Date.now()}-${Math.random().toString(36).substr(2, 6).toUpperCase()}`;
    
    const building = await db.query('SELECT building_name FROM buildings WHERE id = $1', [building_id]);
    
    const result = await db.query(
      `INSERT INTO quotes (
        quote_number, building_id, building_name, bandwidth_mbps, service_type,
        zone, otc, mrc, total_price, customer_name, customer_email,
        customer_phone, notes, created_by
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)
      RETURNING *`,
      [
        quoteNumber, building_id, building.rows[0]?.building_name, bandwidth_mbps,
        service_type, zone, otc, mrc, parseFloat(otc) + parseFloat(mrc),
        customer_name, customer_email, customer_phone, notes, req.user.userId
      ]
    );
    
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Create quote error:', error);
    res.status(500).json({ error: 'Failed to create quote' });
  }
});

// Get all quotes
router.get('/quotes', isAuthenticated, isAdmin, async (req, res) => {
  try {
    const { page = 1, limit = 20 } = req.query;
    const offset = (page - 1) * limit;
    
    const result = await db.query(
      `SELECT q.*, u.name as created_by_name 
       FROM quotes q 
       LEFT JOIN users u ON q.created_by = u.id
       ORDER BY q.created_at DESC
       LIMIT $1 OFFSET $2`,
      [limit, offset]
    );
    
    const total = await db.query('SELECT COUNT(*) FROM quotes');
    
    res.json({
      quotes: result.rows,
      pagination: {
        total: parseInt(total.rows[0].count),
        page: parseInt(page),
        limit: parseInt(limit),
        totalPages: Math.ceil(total.rows[0].count / limit)
      }
    });
  } catch (error) {
    console.error('Get quotes error:', error);
    res.status(500).json({ error: 'Failed to fetch quotes' });
  }
});

module.exports = router;
