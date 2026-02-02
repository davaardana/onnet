const express = require('express');
const router = express.Router();
const db = require('../config/database');

// Search locations
router.get('/search', async (req, res) => {
  try {
    const { q } = req.query;

    if (!q) {
      return res.status(400).json({ error: 'Search query is required' });
    }

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

// Get all locations
router.get('/', async (req, res) => {
  try {
    const result = await db.query(
      'SELECT * FROM locations ORDER BY is_onnet DESC, name ASC'
    );

    res.json({
      locations: result.rows,
      count: result.rows.length
    });
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
