const express = require('express');
const router = express.Router();
const db = require('../config/database');
const { authMiddleware, adminMiddleware } = require('../middleware/auth');

// Helper: calculate price by service type and zone
const calculatePrice = (priceRow, serviceType, zone) => {
  let otc;
  let mrc;

  const validZones = ['Zone 1', 'Zone 2', 'Zone 3', 'Zone 4'];
  if (!validZones.includes(zone)) {
    throw new Error('Invalid zone');
  }

  switch (serviceType) {
    case 'domestic':
      otc = priceRow.domestic_otc;
      if (zone === 'Zone 1') mrc = priceRow.domestic_mrc_zone1;
      else if (zone === 'Zone 2') mrc = priceRow.domestic_mrc_zone2;
      else if (zone === 'Zone 3') mrc = priceRow.domestic_mrc_zone3;
      else if (zone === 'Zone 4') mrc = priceRow.domestic_mrc_zone4;
      else throw new Error('Invalid zone');
      break;
    case 'international':
      otc = priceRow.intl_otc;
      if (zone === 'Zone 1') mrc = priceRow.intl_mrc_zone1;
      else if (zone === 'Zone 2') mrc = priceRow.intl_mrc_zone2;
      else if (zone === 'Zone 3') mrc = priceRow.intl_mrc_zone3;
      else if (zone === 'Zone 4') mrc = priceRow.intl_mrc_zone4;
      else throw new Error('Invalid zone');
      break;
    case 'dia_premium':
      otc = priceRow.dia_otc;
      mrc = priceRow.dia_mrc;
      break;
    case 'idia':
      otc = priceRow.idia_otc;
      mrc = priceRow.idia_mrc;
      break;
    default:
      throw new Error('Invalid service type');
  }

  if (mrc == null || otc == null) {
    throw new Error('Pricing not available for given inputs');
  }

  return { otc, mrc };
};

// ============================================
// PUBLIC ROUTES (NO AUTH)
// ============================================

// Public price list with computed OTC/MRC per service/zone
router.get('/public/pricing', async (req, res) => {
  try {
    const { service_type = 'domestic', zone = 'Zone 1', year = 2026 } = req.query;

    const { rows } = await db.query(
      'SELECT * FROM price_list WHERE year = $1 AND status = $2 ORDER BY bandwidth_mbps',
      [year, 'active']
    );

    const pricing = rows.map((row) => {
      const { otc, mrc } = calculatePrice(row, service_type, zone);
      return {
        id: row.id,
        bandwidth_mbps: row.bandwidth_mbps,
        service_type,
        zone,
        otc,
        mrc,
        year: row.year
      };
    });

    res.json({ pricing });
  } catch (error) {
    console.error('Error fetching public pricing:', error.message || error);
    res.status(400).json({ error: error.message || 'Failed to fetch pricing' });
  }
});

// Public quote calculator (no auth) for FE
router.post('/public/quote', async (req, res) => {
  try {
    const { bandwidth_mbps, service_type = 'domestic', zone, year = 2026, building_id } = req.body;

    if (!bandwidth_mbps) {
      return res.status(400).json({ error: 'Bandwidth is required' });
    }

    let resolvedZone = zone;

    // If building is provided, try to use its zone
    if (building_id) {
      const b = await db.query('SELECT zone, building_name FROM buildings WHERE id = $1', [building_id]);
      if (b.rows.length > 0 && b.rows[0].zone) {
        resolvedZone = b.rows[0].zone;
      }
    }

    if (!resolvedZone) {
      resolvedZone = 'Zone 1';
    }

    const priceResult = await db.query(
      'SELECT * FROM price_list WHERE bandwidth_mbps = $1 AND year = $2 AND status = $3',
      [bandwidth_mbps, year, 'active']
    );

    if (priceResult.rows.length === 0) {
      return res.status(404).json({ error: 'Pricing not found for specified bandwidth' });
    }

    const { otc, mrc } = calculatePrice(priceResult.rows[0], service_type, resolvedZone);

    res.json({
      bandwidth_mbps,
      service_type,
      zone: resolvedZone,
      otc,
      mrc,
      year
    });
  } catch (error) {
    console.error('Error calculating public quote:', error.message || error);
    res.status(400).json({ error: error.message || 'Failed to calculate quote' });
  }
});

// ============================================
// BUILDINGS ROUTES
// ============================================

// Public building search (no auth) for FE usage
router.get('/public/buildings', async (req, res) => {
  try {
    const { q, limit = 10, offset = 0 } = req.query;

    if (!q) {
      return res.status(400).json({ error: 'Query parameter q is required' });
    }

    const searchTerm = `%${q}%`;
    const list = await db.query(
      `SELECT id, building_name, address, city, zone, country
       FROM buildings
       WHERE status = 'active'
         AND (building_name ILIKE $1 OR address ILIKE $1 OR city ILIKE $1)
       ORDER BY building_name
       LIMIT $2 OFFSET $3`,
      [searchTerm, limit, offset]
    );

    const count = await db.query(
      `SELECT COUNT(*) FROM buildings
       WHERE status = 'active'
         AND (building_name ILIKE $1 OR address ILIKE $1 OR city ILIKE $1)`,
      [searchTerm]
    );

    res.json({
      buildings: list.rows,
      total: parseInt(count.rows[0].count),
      limit: parseInt(limit),
      offset: parseInt(offset)
    });
  } catch (error) {
    console.error('Error fetching public buildings:', error);
    res.status(500).json({ error: 'Failed to fetch buildings' });
  }
});

// Get all buildings with search
router.get('/buildings', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const { search, zone, city, limit = 50, offset = 0 } = req.query;
    
    let query = 'SELECT * FROM buildings WHERE 1=1';
    const params = [];
    let paramCount = 1;

    if (search) {
      query += ` AND (building_name ILIKE $${paramCount} OR address ILIKE $${paramCount})`;
      params.push(`%${search}%`);
      paramCount++;
    }

    if (zone) {
      query += ` AND zone = $${paramCount}`;
      params.push(zone);
      paramCount++;
    }

    if (city) {
      query += ` AND city = $${paramCount}`;
      params.push(city);
      paramCount++;
    }

    query += ` ORDER BY building_name LIMIT $${paramCount} OFFSET $${paramCount + 1}`;
    params.push(limit, offset);

    const result = await db.query(query, params);

    // Get total count
    let countQuery = 'SELECT COUNT(*) FROM buildings WHERE 1=1';
    const countParams = [];
    let countParamCount = 1;

    if (search) {
      countQuery += ` AND (building_name ILIKE $${countParamCount} OR address ILIKE $${countParamCount})`;
      countParams.push(`%${search}%`);
      countParamCount++;
    }

    if (zone) {
      countQuery += ` AND zone = $${countParamCount}`;
      countParams.push(zone);
      countParamCount++;
    }

    if (city) {
      countQuery += ` AND city = $${countParamCount}`;
      countParams.push(city);
    }

    const countResult = await db.query(countQuery, countParams);

    res.json({
      buildings: result.rows,
      total: parseInt(countResult.rows[0].count),
      limit: parseInt(limit),
      offset: parseInt(offset)
    });
  } catch (error) {
    console.error('Error fetching buildings:', error);
    res.status(500).json({ error: 'Failed to fetch buildings' });
  }
});

// Get building by ID
router.get('/buildings/:id', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query('SELECT * FROM buildings WHERE id = $1', [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Building not found' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error fetching building:', error);
    res.status(500).json({ error: 'Failed to fetch building' });
  }
});

// Create building
router.post('/buildings', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const { building_name, address, zone, city, country, status } = req.body;

    if (!building_name || !address) {
      return res.status(400).json({ error: 'Building name and address are required' });
    }

    const result = await db.query(
      `INSERT INTO buildings (building_name, address, zone, city, country, status) 
       VALUES ($1, $2, $3, $4, $5, $6) 
       RETURNING *`,
      [building_name, address, zone || null, city || null, country || 'Indonesia', status || 'active']
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Error creating building:', error);
    res.status(500).json({ error: 'Failed to create building' });
  }
});

// Update building
router.put('/buildings/:id', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const { id } = req.params;
    const { building_name, address, zone, city, country, status } = req.body;

    const result = await db.query(
      `UPDATE buildings 
       SET building_name = $1, address = $2, zone = $3, city = $4, country = $5, status = $6, updated_at = CURRENT_TIMESTAMP
       WHERE id = $7 
       RETURNING *`,
      [building_name, address, zone, city, country, status, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Building not found' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error updating building:', error);
    res.status(500).json({ error: 'Failed to update building' });
  }
});

// Delete building
router.delete('/buildings/:id', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query('DELETE FROM buildings WHERE id = $1 RETURNING *', [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Building not found' });
    }

    res.json({ message: 'Building deleted successfully' });
  } catch (error) {
    console.error('Error deleting building:', error);
    res.status(500).json({ error: 'Failed to delete building' });
  }
});

// ============================================
// PRICE LIST ROUTES
// ============================================

// Get price list with filters
router.get('/pricing', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const { bandwidth_mbps, year = 2026 } = req.query;
    
    let query = 'SELECT * FROM price_list WHERE year = $1';
    const params = [year];
    let paramCount = 2;

    if (bandwidth_mbps) {
      query += ` AND bandwidth_mbps = $${paramCount}`;
      params.push(bandwidth_mbps);
    }

    query += ' ORDER BY bandwidth_mbps';

    const result = await db.query(query, params);
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching pricing:', error);
    res.status(500).json({ error: 'Failed to fetch pricing' });
  }
});

// Get quote calculation (admin) and log into quote_logs
router.post('/quote', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const { bandwidth_mbps, service_type = 'domestic', zone, building_id } = req.body;

    if (!bandwidth_mbps) {
      return res.status(400).json({ error: 'Bandwidth is required' });
    }

    let resolvedZone = zone;
    let building = null;
    if (building_id) {
      const b = await db.query('SELECT id, building_name, address, city, zone FROM buildings WHERE id = $1', [building_id]);
      if (b.rows.length > 0) {
        building = b.rows[0];
        if (!resolvedZone && building.zone) {
          resolvedZone = building.zone;
        }
      }
    }

    if (!resolvedZone) {
      resolvedZone = 'Zone 1';
    }

    const priceResult = await db.query(
      'SELECT * FROM price_list WHERE bandwidth_mbps = $1 AND year = 2026 AND status = $2',
      [bandwidth_mbps, 'active']
    );

    if (priceResult.rows.length === 0) {
      return res.status(404).json({ error: 'Pricing not found for specified bandwidth' });
    }

    const price = priceResult.rows[0];
    const pricing = calculatePrice(price, service_type, resolvedZone);

    // Log into quote_logs (non-breaking vs legacy quotes table)
    const log = await db.query(
      `INSERT INTO quote_logs (
         user_id, source, bandwidth_mbps, service_type, zone, price_list_id,
         building_id, building_name, otc, mrc, status
       ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, 'pending')
       RETURNING *`,
      [
        req.user.userId,
        'admin_quote',
        bandwidth_mbps,
        service_type,
        resolvedZone,
        price.id,
        building ? building.id : null,
        building ? building.building_name : null,
        pricing.otc,
        pricing.mrc
      ]
    );

    res.json({
      quote: {
        bandwidth_mbps,
        service_type,
        zone: resolvedZone,
        otc: pricing.otc,
        mrc: pricing.mrc,
        price_list_id: price.id
      },
      building,
      price,
      log: log.rows[0]
    });
  } catch (error) {
    console.error('Error creating quote:', error);
    res.status(500).json({ error: 'Failed to create quote' });
  }
});

// Public quote calculation (no auth) for FE instant quote + log into quote_logs
router.post('/public/quote', async (req, res) => {
  try {
    const { bandwidth_mbps, service_type, zone, building_id, location_query, whatsapp_number } = req.body;

    if (!bandwidth_mbps || !service_type) {
      return res.status(400).json({ error: 'Bandwidth and service type are required' });
    }

    let resolvedZone = zone;

    const priceResult = await db.query(
      'SELECT * FROM price_list WHERE bandwidth_mbps = $1 AND year = 2026 AND status = $2',
      [bandwidth_mbps, 'active']
    );

    if (priceResult.rows.length === 0) {
      return res.status(404).json({ error: 'Pricing not found for specified bandwidth' });
    }

    let building = null;
    if (building_id) {
      const b = await db.query(
        'SELECT id, building_name, address, city, zone, country FROM buildings WHERE id = $1',
        [building_id]
      );
      if (b.rows.length > 0) {
        building = b.rows[0];
        if (!resolvedZone && building.zone) {
          resolvedZone = building.zone;
        }
      }
    }

    if (!resolvedZone) {
      resolvedZone = 'Zone 1';
    }

    let pricing;
    try {
      pricing = calculatePrice(priceResult.rows[0], service_type, resolvedZone);
    } catch (err) {
      return res.status(400).json({ error: err.message });
    }

    // Log anonymously
    const log = await db.query(
      `INSERT INTO quote_logs (
         source, bandwidth_mbps, service_type, zone, price_list_id,
         building_id, building_name, location_query, otc, mrc, status, whatsapp_number
       ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, 'pending', $11)
       RETURNING *`,
      [
        'public_quote',
        bandwidth_mbps,
        service_type,
        resolvedZone,
        priceResult.rows[0].id,
        building ? building.id : null,
        building ? building.building_name : null,
        location_query || null,
        pricing.otc,
        pricing.mrc,
        whatsapp_number || null
      ]
    );

    res.json({
      bandwidth_mbps: Number(bandwidth_mbps),
      service_type,
      zone: resolvedZone,
      otc: pricing.otc,
      mrc: pricing.mrc,
      currency: 'IDR',
      year: priceResult.rows[0].year,
      building,
      log: log.rows[0]
    });
  } catch (error) {
    console.error('Error creating public quote:', error);
    res.status(500).json({ error: 'Failed to create quote' });
  }
});

// Get all quotes
router.get('/quotes', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const { status, limit = 50, offset = 0 } = req.query;
    
    let query = 'SELECT q.*, u.name as user_name, u.email as user_email FROM quotes q LEFT JOIN users u ON q.user_id = u.id WHERE 1=1';
    const params = [];
    let paramCount = 1;

    if (status) {
      query += ` AND q.status = $${paramCount}`;
      params.push(status);
      paramCount++;
    }

    query += ` ORDER BY q.created_at DESC LIMIT $${paramCount} OFFSET $${paramCount + 1}`;
    params.push(limit, offset);

    const result = await db.query(query, params);

    // Get total count
    let countQuery = 'SELECT COUNT(*) FROM quotes WHERE 1=1';
    const countParams = [];
    if (status) {
      countQuery += ' AND status = $1';
      countParams.push(status);
    }

    const countResult = await db.query(countQuery, countParams);

    res.json({
      quotes: result.rows,
      total: parseInt(countResult.rows[0].count),
      limit: parseInt(limit),
      offset: parseInt(offset)
    });
  } catch (error) {
    console.error('Error fetching quotes:', error);
    res.status(500).json({ error: 'Failed to fetch quotes' });
  }
});

// Update quote status
router.patch('/quotes/:id/status', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    if (!['draft', 'sent', 'approved', 'rejected'].includes(status)) {
      return res.status(400).json({ error: 'Invalid status' });
    }

    const result = await db.query(
      'UPDATE quotes SET status = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2 RETURNING *',
      [status, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Quote not found' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error updating quote:', error);
    res.status(500).json({ error: 'Failed to update quote' });
  }
});

module.exports = router;
