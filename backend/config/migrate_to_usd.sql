-- Migration: Convert all prices from IDR to USD
-- Date: 2026-02-27
-- Exchange Rate: 1 USD = Rp 15,500
-- Description: Converts all price columns in price_list table from Indonesian Rupiah to US Dollars

BEGIN;

-- Backup note: Prices are divided by 15500 and rounded to nearest integer
UPDATE price_list SET
  -- Domestic prices
  domestic_otc = ROUND(domestic_otc / 15500),
  domestic_mrc_zone1 = ROUND(domestic_mrc_zone1 / 15500),
  domestic_mrc_zone2 = ROUND(domestic_mrc_zone2 / 15500),
  domestic_mrc_zone3 = ROUND(domestic_mrc_zone3 / 15500),
  domestic_mrc_zone4 = ROUND(domestic_mrc_zone4 / 15500),
  
  -- International prices
  intl_otc = ROUND(intl_otc / 15500),
  intl_mrc_zone1 = ROUND(intl_mrc_zone1 / 15500),
  intl_mrc_zone2 = ROUND(intl_mrc_zone2 / 15500),
  intl_mrc_zone3 = ROUND(intl_mrc_zone3 / 15500),
  intl_mrc_zone4 = ROUND(intl_mrc_zone4 / 15500),
  
  -- DIA Premium prices
  dia_otc = ROUND(dia_otc / 15500),
  dia_mrc = ROUND(dia_mrc / 15500),
  
  -- IDIA prices
  idia_otc = ROUND(idia_otc / 15500),
  idia_mrc = ROUND(idia_mrc / 15500),
  
  -- P2P Metronet prices
  metronet_otc = ROUND(COALESCE(metronet_otc, 0) / 15500),
  metronet_mrc_zone1 = ROUND(COALESCE(metronet_mrc_zone1, 0) / 15500),
  metronet_mrc_zone2 = ROUND(COALESCE(metronet_mrc_zone2, 0) / 15500),
  metronet_mrc_zone3 = ROUND(COALESCE(metronet_mrc_zone3, 0) / 15500),
  metronet_mrc_zone4 = ROUND(COALESCE(metronet_mrc_zone4, 0) / 15500),
  
  -- DC2DC prices
  dc2dc_otc = ROUND(COALESCE(dc2dc_otc, 0) / 15500),
  dc2dc_mrc = ROUND(COALESCE(dc2dc_mrc, 0) / 15500),
  
  -- Dark Fiber prices
  darkfiber_otc = ROUND(COALESCE(darkfiber_otc, 0) / 15500),
  darkfiber_mrc_per_core = ROUND(COALESCE(darkfiber_mrc_per_core, 0) / 15500)
WHERE status = 'active';

-- Add note to indicate currency is now USD
COMMENT ON TABLE price_list IS 'Price list table - All prices stored in USD as of 2026-02-27';

COMMIT;

-- Verification query (run after migration):
-- SELECT bandwidth_mbps, domestic_otc, domestic_mrc_zone1, intl_otc, intl_mrc_zone1 
-- FROM price_list 
-- WHERE bandwidth_mbps IN (2, 10, 100) AND status='active' 
-- ORDER BY bandwidth_mbps;
