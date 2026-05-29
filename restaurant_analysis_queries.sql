-- Restaurant Industry 25-Year Analysis (2000-2024)
-- SQL Queries for Portfolio Project
-- Database: restaurant_analysis.db
-- Tables: companies, annual_financials, macro_context

-- ============================================================
-- Query 1: Sanity check — verify joins work across all tables
-- ============================================================
SELECT 
    c.company_name,
    c.tier,
    af.fiscal_year,
    af.total_revenue_m,
    af.net_margin_pct
FROM annual_financials af
JOIN companies c ON af.company_id = c.company_id
WHERE af.total_revenue_m IS NOT NULL
ORDER BY c.company_name, af.fiscal_year;

-- ============================================================
-- Query 2: Average net margin by tier across full dataset
-- Fast food margin inflated by franchise model (no direct labor/food costs)
-- ============================================================
SELECT 
    c.tier,
    ROUND(AVG(af.net_margin_pct), 2) AS avg_net_margin
FROM annual_financials af
JOIN companies c ON af.company_id = c.company_id
WHERE af.net_margin_pct IS NOT NULL
GROUP BY c.tier
ORDER BY avg_net_margin DESC;

-- ============================================================
-- Query 3: COVID impact by tier — 2019 vs 2020 revenue comparison
-- Fast casual grew during COVID; upscale hit hardest at -19.42%
-- ============================================================
SELECT
    c.tier,
    ROUND(AVG(CASE WHEN af.fiscal_year = 2019 THEN af.total_revenue_m END), 2) AS avg_revenue_2019,
    ROUND(AVG(CASE WHEN af.fiscal_year = 2020 THEN af.total_revenue_m END), 2) AS avg_revenue_2020,
    ROUND(((AVG(CASE WHEN af.fiscal_year = 2020 THEN af.total_revenue_m END) - 
            AVG(CASE WHEN af.fiscal_year = 2019 THEN af.total_revenue_m END)) / 
            AVG(CASE WHEN af.fiscal_year = 2019 THEN af.total_revenue_m END)) * 100, 2) AS pct_change
FROM annual_financials af
JOIN companies c ON af.company_id = c.company_id
WHERE af.total_revenue_m IS NOT NULL
GROUP BY c.tier
ORDER BY pct_change ASC;

-- ============================================================
-- Query 4: Best performing company by average net margin
-- Includes worst and best year margin to show volatility range
-- ============================================================
SELECT
    c.company_name,
    c.tier,
    ROUND(AVG(af.net_margin_pct), 2) AS avg_net_margin,
    ROUND(MIN(af.net_margin_pct), 2) AS worst_year_margin,
    ROUND(MAX(af.net_margin_pct), 2) AS best_year_margin
FROM annual_financials af
JOIN companies c ON af.company_id = c.company_id
WHERE af.net_margin_pct IS NOT NULL
GROUP BY c.company_name, c.tier
ORDER BY avg_net_margin DESC;

-- ============================================================
-- Query 5: Same store sales by tier during key economic events
-- Casual dining worst hit in COVID (-19.3%); fast casual grew (+10.9%)
-- Note: Yum! reflects Taco Bell flagship; Brinker reflects Chili's flagship;
--       Darden reflects Olive Garden flagship
-- ============================================================
SELECT
    c.tier,
    ROUND(AVG(CASE WHEN af.fiscal_year BETWEEN 2008 AND 2009 
        THEN af.same_store_sales_pct END), 2) AS recession_sss,
    ROUND(AVG(CASE WHEN af.fiscal_year = 2020 
        THEN af.same_store_sales_pct END), 2) AS covid_sss,
    ROUND(AVG(CASE WHEN af.fiscal_year BETWEEN 2021 AND 2022 
        THEN af.same_store_sales_pct END), 2) AS recovery_sss
FROM annual_financials af
JOIN companies c ON af.company_id = c.company_id
WHERE af.same_store_sales_pct IS NOT NULL
GROUP BY c.tier
ORDER BY covid_sss ASC;

-- ============================================================
-- Query 6: Location growth by decade
-- Yum! 2000s growth reflects China expansion pre-spinoff
-- Brinker negative 2010s reflects brand consolidation/divestiture
-- ============================================================
SELECT
    c.company_name,
    c.tier,
    SUM(CASE WHEN af.fiscal_year BETWEEN 2000 AND 2009 
        THEN af.net_new_locations END) AS locations_added_2000s,
    SUM(CASE WHEN af.fiscal_year BETWEEN 2010 AND 2019 
        THEN af.net_new_locations END) AS locations_added_2010s,
    SUM(CASE WHEN af.fiscal_year BETWEEN 2020 AND 2024 
        THEN af.net_new_locations END) AS locations_added_2020s
FROM annual_financials af
JOIN companies c ON af.company_id = c.company_id
WHERE af.net_new_locations IS NOT NULL
GROUP BY c.company_name, c.tier
ORDER BY c.tier, locations_added_2010s DESC;

-- ============================================================
-- Query 7: Macro context join — revenue growth vs food inflation and GDP
-- Shows how each tier responded during recession, COVID, and recovery
-- Three-table join demonstrating relational data modeling
-- ============================================================
SELECT
    af.fiscal_year,
    c.tier,
    ROUND(AVG(af.revenue_yoy_pct), 2) AS avg_revenue_growth,
    mc.food_cpi_yoy_pct AS food_inflation,
    mc.us_gdp_growth_pct AS gdp_growth,
    mc.event_label
FROM annual_financials af
JOIN companies c ON af.company_id = c.company_id
JOIN macro_context mc ON af.fiscal_year = mc.fiscal_year
WHERE af.revenue_yoy_pct IS NOT NULL
AND af.fiscal_year IN (2008, 2009, 2020, 2021, 2022)
GROUP BY af.fiscal_year, c.tier, mc.food_cpi_yoy_pct, mc.us_gdp_growth_pct, mc.event_label
ORDER BY af.fiscal_year, c.tier;

-- ============================================================
-- Query 8: Consistency scoring — margin range and years above 8%
-- Texas Roadhouse: smallest margin range (5.39) and 19/21 years above 8%
-- Demonstrates how to measure stability not just average performance
-- ============================================================
SELECT
    c.company_name,
    c.tier,
    ROUND(AVG(af.net_margin_pct), 2) AS avg_margin,
    ROUND(MAX(af.net_margin_pct) - MIN(af.net_margin_pct), 2) AS margin_range,
    COUNT(CASE WHEN af.net_margin_pct >= 8.0 THEN 1 END) AS years_above_8pct,
    COUNT(af.net_margin_pct) AS total_years
FROM annual_financials af
JOIN companies c ON af.company_id = c.company_id
WHERE af.net_margin_pct IS NOT NULL
GROUP BY c.company_name, c.tier
ORDER BY margin_range ASC;