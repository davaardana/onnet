const db = require('../config/database');

// Simple audit logger to capture key actions
async function recordAudit(userId, action, resource, metadata = null, req = {}) {
  try {
    const ip = req.ip || null;
    const userAgent = req.headers ? req.headers['user-agent'] : null;
    await db.query(
      `INSERT INTO audit_logs (user_id, action, resource, ip_address, user_agent, metadata)
       VALUES ($1, $2, $3, $4, $5, $6)`,
      [userId || null, action, resource, ip, userAgent, metadata]
    );
  } catch (error) {
    // Do not block the request on audit failure
    console.error('Audit log failed:', error.message || error);
  }
}

module.exports = { recordAudit };
