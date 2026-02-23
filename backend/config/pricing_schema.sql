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

CREATE INDEX IF NOT EXISTS idx_buildings_name ON buildings(building_name);
CREATE INDEX IF NOT EXISTS idx_buildings_city ON buildings(city);
CREATE INDEX IF NOT EXISTS idx_buildings_zone ON buildings(zone);

-- Table: price_list
-- Covers: DIA, Broadband (domestic/international), DIA Premium, IDIA,
--         Metro Ethernet, DC-DC Interconnection, Dark Fiber
CREATE TABLE IF NOT EXISTS price_list (
  id SERIAL PRIMARY KEY,
  bandwidth_mbps INTEGER NOT NULL,

  -- Domestic Internet (Broadband / DIA standard)
  domestic_otc NUMERIC(12,2),
  domestic_mrc_zone1 NUMERIC(12,2),
  domestic_mrc_zone2 NUMERIC(12,2),
  domestic_mrc_zone3 NUMERIC(12,2),
  domestic_mrc_zone4 NUMERIC(12,2),

  -- International Internet
  intl_otc NUMERIC(12,2),
  intl_mrc_zone1 NUMERIC(12,2),
  intl_mrc_zone2 NUMERIC(12,2),
  intl_mrc_zone3 NUMERIC(12,2),
  intl_mrc_zone4 NUMERIC(12,2),

  -- DIA Premium
  dia_otc NUMERIC(12,2),
  dia_mrc NUMERIC(12,2),

  -- IDIA (International DIA)
  idia_bw INTEGER,
  idia_otc NUMERIC(12,2),
  idia_mrc NUMERIC(12,2),

  -- Metro Ethernet Local Loop (P2P, zone-based)
  metronet_otc NUMERIC(12,2),
  metronet_mrc_zone1 NUMERIC(12,2),
  metronet_mrc_zone2 NUMERIC(12,2),
  metronet_mrc_zone3 NUMERIC(12,2),
  metronet_mrc_zone4 NUMERIC(12,2),

  -- DC to DC Interconnection (P2P, flat price)
  dc2dc_otc NUMERIC(12,2),
  dc2dc_mrc NUMERIC(12,2),

  -- Dark Fiber (P2P, per core pricing)
  darkfiber_otc NUMERIC(12,2),
  darkfiber_mrc_per_core NUMERIC(12,2),

  year INTEGER DEFAULT 2026,
  status VARCHAR(50) DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT price_list_bandwidth_mbps_year_key UNIQUE (bandwidth_mbps, year)
);

CREATE INDEX IF NOT EXISTS idx_price_bandwidth ON price_list(bandwidth_mbps);
CREATE INDEX IF NOT EXISTS idx_price_bandwidth_year ON price_list(bandwidth_mbps, year);
CREATE INDEX IF NOT EXISTS idx_price_status ON price_list(status);
CREATE INDEX IF NOT EXISTS idx_price_year ON price_list(year);

-- Table: orders (key columns for P2P service tracking)
-- ALTER for existing DBs:
ALTER TABLE orders ADD COLUMN IF NOT EXISTS service_category VARCHAR(50);
ALTER TABLE orders ADD COLUMN IF NOT EXISTS a_end TEXT;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS b_end TEXT;

-- Table: quote_logs (P2P tracking)
ALTER TABLE quote_logs ADD COLUMN IF NOT EXISTS service_category VARCHAR(50);
ALTER TABLE quote_logs ADD COLUMN IF NOT EXISTS a_end TEXT;
ALTER TABLE quote_logs ADD COLUMN IF NOT EXISTS b_end TEXT;

-- Migrate price_list for existing DBs
ALTER TABLE price_list ADD COLUMN IF NOT EXISTS metronet_otc NUMERIC(12,2);
ALTER TABLE price_list ADD COLUMN IF NOT EXISTS metronet_mrc_zone1 NUMERIC(12,2);
ALTER TABLE price_list ADD COLUMN IF NOT EXISTS metronet_mrc_zone2 NUMERIC(12,2);
ALTER TABLE price_list ADD COLUMN IF NOT EXISTS metronet_mrc_zone3 NUMERIC(12,2);
ALTER TABLE price_list ADD COLUMN IF NOT EXISTS metronet_mrc_zone4 NUMERIC(12,2);
ALTER TABLE price_list ADD COLUMN IF NOT EXISTS dc2dc_otc NUMERIC(12,2);
ALTER TABLE price_list ADD COLUMN IF NOT EXISTS dc2dc_mrc NUMERIC(12,2);
ALTER TABLE price_list ADD COLUMN IF NOT EXISTS darkfiber_otc NUMERIC(12,2);
ALTER TABLE price_list ADD COLUMN IF NOT EXISTS darkfiber_mrc_per_core NUMERIC(12,2);

COMMENT ON TABLE buildings IS 'List of buildings/locations for network services';
COMMENT ON TABLE price_list IS 'Price book for bandwidth services (2026) - DIA, Broadband, Metro Ethernet, DC-DC, Dark Fiber';

