-- Buildings Management Tables for Netpoint

-- Buildings table
CREATE TABLE IF NOT EXISTS buildings (
    id SERIAL PRIMARY KEY,
    building_name VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    zone_code VARCHAR(10),
    zone_name VARCHAR(100),
    zone_number INTEGER,
    zone_details TEXT,
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index for faster search
CREATE INDEX IF NOT EXISTS idx_buildings_name ON buildings(building_name);
CREATE INDEX IF NOT EXISTS idx_buildings_zone ON buildings(zone_code);
CREATE INDEX IF NOT EXISTS idx_buildings_status ON buildings(status);

-- Price List table (2026)
CREATE TABLE IF NOT EXISTS price_list (
    id SERIAL PRIMARY KEY,
    bandwidth_mbps INTEGER NOT NULL,
    
    -- Domestic Ethernet
    domestic_otc DECIMAL(12,2),
    domestic_mrc_zone1 DECIMAL(12,2),
    domestic_mrc_zone2 DECIMAL(12,2),
    domestic_mrc_zone3 DECIMAL(12,2),
    domestic_mrc_zone4 DECIMAL(12,2),
    
    -- International Ethernet
    intl_otc DECIMAL(12,2),
    intl_mrc_zone1 DECIMAL(12,2),
    intl_mrc_zone2 DECIMAL(12,2),
    intl_mrc_zone3 DECIMAL(12,2),
    intl_mrc_zone4 DECIMAL(12,2),
    
    -- DIA Premium
    dia_otc DECIMAL(12,2),
    dia_mrc DECIMAL(12,2),
    
    -- IDIA Up To USD
    idia_bw INTEGER,
    idia_otc DECIMAL(12,2),
    idia_mrc DECIMAL(12,2),
    
    year INTEGER DEFAULT 2026,
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(bandwidth_mbps, year)
);

-- Create index for bandwidth lookup
CREATE INDEX IF NOT EXISTS idx_price_bandwidth ON price_list(bandwidth_mbps);
CREATE INDEX IF NOT EXISTS idx_price_year ON price_list(year);

-- Quotes/Offers table
CREATE TABLE IF NOT EXISTS quotes (
    id SERIAL PRIMARY KEY,
    quote_number VARCHAR(50) UNIQUE NOT NULL,
    building_id INTEGER REFERENCES buildings(id),
    building_name VARCHAR(255),
    bandwidth_mbps INTEGER,
    service_type VARCHAR(50), -- 'domestic', 'international', 'dia', 'idia'
    zone INTEGER,
    otc DECIMAL(12,2),
    mrc DECIMAL(12,2),
    total_price DECIMAL(12,2),
    customer_name VARCHAR(255),
    customer_email VARCHAR(255),
    customer_phone VARCHAR(50),
    notes TEXT,
    status VARCHAR(50) DEFAULT 'draft', -- draft, sent, accepted, rejected
    created_by INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_quotes_building ON quotes(building_id);
CREATE INDEX IF NOT EXISTS idx_quotes_status ON quotes(status);
CREATE INDEX IF NOT EXISTS idx_quotes_created_by ON quotes(created_by);

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for updated_at
DROP TRIGGER IF EXISTS update_buildings_updated_at ON buildings;
CREATE TRIGGER update_buildings_updated_at BEFORE UPDATE ON buildings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_price_list_updated_at ON price_list;
CREATE TRIGGER update_price_list_updated_at BEFORE UPDATE ON price_list
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_quotes_updated_at ON quotes;
CREATE TRIGGER update_quotes_updated_at BEFORE UPDATE ON quotes
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
