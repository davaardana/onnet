const express = require('express');
const router = express.Router();
const db = require('../config/database');

// Simple in-memory cache
const cache = {
  allLocations: null,
  timestamp: null,
  TTL: 5 * 60 * 1000 // 5 minutes
};

// Search locations with caching
router.get('/search', async (req, res) => {
  try {
    const { q } = req.query;

    if (!q) {
      return res.status(400).json({ error: 'Search query is required' });
    }

    // Set cache headers
    res.set('Cache-Control', 'public, max-age=300'); // 5 minutes

    const result = await db.query(
      `SELECT * FROM locations 
       WHERE LOWER(name) LIKE LOWER($1) 
       OR LOWER(address) LIKE LOWER($1)
       OR LOWER(city) LIKE LOWER($1)
       ORDER BY is_onnet DESC, name ASC`,
      [`%${q}%`]
    );

    res.json({
      locations: result.rows,
      count: result.rows.length
    });
  } catch (error) {
    console.error('Search error:', error);
    res.status(500).json({ error: 'Server error during search' });
  }
});

// Get all locations with caching
router.get('/', async (req, res) => {
  try {
    const now = Date.now();
    
    // Check if cache is valid
    if (cache.allLocations && cache.timestamp && (now - cache.timestamp) < cache.TTL) {
      res.set('Cache-Control', 'public, max-age=300');
      res.set('X-Cache', 'HIT');
      return res.json(cache.allLocations);
    }

    // Fetch from database
    const result = await db.query(
      'SELECT * FROM locations ORDER BY is_onnet DESC, name ASC'
    );

    const response = {
      locations: result.rows,
      count: result.rows.length
    };

    // Update cache
    cache.allLocations = response;
    cache.timestamp = now;

    res.set('Cache-Control', 'public, max-age=300');
    res.set('X-Cache', 'MISS');
    res.json(response);
  } catch (error) {
    console.error('Get locations error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Get location by ID
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    const result = await db.query(
      'SELECT * FROM locations WHERE id = $1',
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Location not found' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error('Get location error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router;
