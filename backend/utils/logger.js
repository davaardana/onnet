// Structured Logger for Netpoint Backend
const getTimestamp = () => new Date().toISOString();

const formatLog = (level, message, meta = {}) => {
  const isProd = process.env.NODE_ENV === 'production';
  const entry = {
    timestamp: getTimestamp(),
    level,
    message,
    ...(meta && Object.keys(meta).length ? { meta } : {})
  };
  return isProd
    ? JSON.stringify(entry)
    : `[${entry.timestamp}] [${level}] ${message} ${
        meta && Object.keys(meta).length ? JSON.stringify(meta) : ''
      }`;
};

const logger = {
  info: (message, meta) => console.log(formatLog('INFO', message, meta)),
  warn: (message, meta) => console.warn(formatLog('WARN', message, meta)),
  error: (message, meta) => console.error(formatLog('ERROR', message, meta)),
  debug: (message, meta) => {
    if (process.env.NODE_ENV !== 'production') {
      console.log(formatLog('DEBUG', message, meta));
    }
  },
  // Express request logging middleware
  httpLogger: (req, res, next) => {
    const start = Date.now();
    res.on('finish', () => {
      const duration = Date.now() - start;
      const meta = {
        method: req.method,
        url: req.originalUrl || req.url,
        status: res.statusCode,
        durationMs: duration,
        ip: req.ip || req.headers['x-forwarded-for'] || req.socket.remoteAddress
      };
      const message = `${req.method} ${req.originalUrl || req.url} ${res.statusCode} in ${duration}ms`;
      if (res.statusCode >= 500) {
        logger.error(message, meta);
      } else if (res.statusCode >= 400) {
        logger.warn(message, meta);
      } else {
        logger.info(message, meta);
      }
    });
    next();
  }
};

module.exports = logger;
