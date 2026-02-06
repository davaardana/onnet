-- Pricing Schema for Netpoint (aligned to current DB)
-- Buildings and Price Book Tables

-- Table: buildings
CREATE TABLE IF NOT EXISTS buildings (
  id SERIAL PRIMARY KEY,
  building_name VARCHAR(255) NOT NULL,
  address TEXT NOT NULL,
  zone VARCHAR(50),
  country VARCHAR(100) DEFAULT 'Indonesia',
  city VARCHAR(100),
  status VARCHAR(50) DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_buildings_name ON buildings(building_name);
CREATE INDEX idx_buildings_city ON buildings(city);
CREATE INDEX idx_buildings_zone ON buildings(zone);

CREATE TABLE IF NOT EXISTS price_list (
  id SERIAL PRIMARY KEY,
  bandwidth_mbps INTEGER NOT NULL,
  domestic_otc NUMERIC(12,2),
  domestic_mrc_zone1 NUMERIC(12,2),
  domestic_mrc_zone2 NUMERIC(12,2),
  domestic_mrc_zone3 NUMERIC(12,2),
  domestic_mrc_zone4 NUMERIC(12,2),
  intl_otc NUMERIC(12,2),
  intl_mrc_zone1 NUMERIC(12,2),
  intl_mrc_zone2 NUMERIC(12,2),
  intl_mrc_zone3 NUMERIC(12,2),
  intl_mrc_zone4 NUMERIC(12,2),
  dia_otc NUMERIC(12,2),
  dia_mrc NUMERIC(12,2),
  idia_bw INTEGER,
  idia_otc NUMERIC(12,2),
  idia_mrc NUMERIC(12,2),
  year INTEGER DEFAULT 2026,
  status VARCHAR(50) DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT price_list_bandwidth_mbps_year_key UNIQUE (bandwidth_mbps, year)
);

CREATE INDEX idx_price_bandwidth ON price_list(bandwidth_mbps);
CREATE INDEX idx_price_bandwidth_year ON price_list(bandwidth_mbps, year);
CREATE INDEX idx_price_status ON price_list(status);
CREATE INDEX idx_price_year ON price_list(year);

-- Quotes table already exists in production with a slightly different schema
-- (created_by, quote_number, zone as integer). Migration is skipped to avoid conflict.

COMMENT ON TABLE buildings IS 'List of buildings/locations for network services';
COMMENT ON TABLE price_list IS 'Price book for bandwidth services (2026)';
