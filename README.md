# U.S. Restaurant Industry Analysis — 2000 to 2024

A 25-year financial analysis of eight publicly traded restaurant companies across four 
market tiers. Built as Project 4 of 5 in a data analytics portfolio progression.

---

## Portfolio Context

| Project | Topic | Tools |
|---|---|---|
| 1 | Atlanta City Analysis | SQL, Tableau |
| 2 | Sports Analysis | SQL, Tableau |
| 3 | Video Game Analysis | SQL, Tableau |
| **4** | **U.S. Restaurant Industry 2000–2024** | **Google Sheets, SQLite, Tableau** |
| 5 | Financial Analysis Capstone | TBD |

---

## Project Overview

The U.S. restaurant industry crossed $1 trillion in annual revenue for the first time 
in 2024. This project examines how four distinct market tiers — fast food, fast casual, 
casual dining, and upscale — navigated 25 years of economic turbulence including the 
dot-com recession, the 2008 Great Recession, the rise of fast casual, and the 
COVID-19 pandemic.

Eight publicly traded companies were selected to represent each tier with meaningful 
public data windows across the century.

| Company | Ticker | Tier | Public Data Window |
|---|---|---|---|
| McDonald's | MCD | Fast Food | 2000–2024 |
| Yum! Brands | YUM | Fast Food | 2000–2024 |
| Chipotle | CMG | Fast Casual | 2006–2024 |
| Panera Bread | PNRA | Fast Casual | 2000–2016 |
| Darden Restaurants | DRI | Casual Dining | 2000–2024 |
| Brinker International | EAT | Casual Dining | 2000–2024 |
| Texas Roadhouse | TXRH | Upscale | 2004–2024 |
| Ruth's Chris | RUTH | Upscale | 2005–2022 |

---

## Tools & Skills

- **Google Sheets** — data collection, cleaning, and relational table structuring
- **SQLite / DB Browser** — relational database design and analytical queries
- **Tableau Public** — interactive dashboard visualization and narrative storytelling

---

## Data Sources

- SEC 10-K annual filings
- Macrotrends.net historical financials
- Bureau of Labor Statistics — food CPI (CUUR0000SEFV) and employment (CEU7072200001)
- Federal Reserve Economic Data (FRED) — annual GDP growth
- National Restaurant Association annual reports
- Claude AI synthesis for gap-filling and cross-source validation

---

## Database Schema

Three relational tables modeled after a star schema:

- **companies** — dimension table, 8 rows, static company reference data
- **annual_financials** — fact table, 200 rows, one record per company per year
- **macro_context** — environment table, 25 rows, one record per year

Key fields include total revenue, net income, net margin, operating income, 
same store sales growth, total locations, stock price, market cap, food CPI, 
restaurant employment, federal minimum wage, and GDP growth.

---

## Key Findings

**1. Fast casual was COVID-proof.**
Fast casual was the only tier to grow revenue during 2020 (+7.6%), driven by 
Chipotle's digital ordering infrastructure. Every other tier declined.

**2. Casual dining took the hardest COVID hit.**
Casual dining same store sales dropped -19.3% in 2020 — nearly four times worse 
than fast food at -5.6%. The recovery in 2021 (+22%) was equally dramatic.

**3. Texas Roadhouse is the consistency story of the century.**
Texas Roadhouse maintained the tightest net margin range of any company in the 
dataset — just 5.39 percentage points across 21 years — and exceeded 8% margins 
in 19 of those 21 years.

**4. The minimum wage vs inflation gap tells a hidden story.**
The federal minimum wage has been frozen at $7.25 since 2009 while food away 
from home CPI rose 65% over the same period. This pressure is visible in operator 
labor cost trends across the dataset.

**5. Not every revenue drop is a collapse.**
Yum! Brands revenue fell 51% in 2016 and Darden fell 21% in 2014 — both due to 
strategic divestitures, not operational failure. Context matters in financial analysis.

---

## Dashboards

Full interactive analysis published on Tableau Public:
👉 **[View on Tableau Public](https://public.tableau.com/app/profile/bryce.gardner/vizzes)**

---

### Dashboard 1 — The Big Picture
*Industry-wide context: revenue growth, inflation vs wages, and employment 2000–2024*

![Dashboard 1 — The Big Picture](images/dashboard1_big_picture.png)

Three macro-level charts share the same time axis, allowing direct visual comparison 
of how the industry's revenue, price environment, and workforce responded to the same 
economic events. The Great Recession and COVID-19 reference lines anchor the narrative.

---

### Dashboard 2 — Four Tiers, One Century
*Competitive financial analysis: revenue, margins, and consistency by company and tier*

![Dashboard 2 — Four Tiers, One Century](images/dashboard2_four_tiers.png)

The revenue line chart shows all eight companies across 25 years — McDonald's 
dominating at the top, Chipotle's steep climb from nothing, Panera going dark after 
2016, and Yum!'s cliff drop reflecting the China spinoff. The scatter plot positions 
every company by average margin vs margin volatility, making Texas Roadhouse's 
outlier consistency immediately visible.

---

### Dashboard 3 — Survive and Thrive
*Crisis response and recovery: same store sales during economic events and margin heat map*

![Dashboard 3 — Survive and Thrive](images/dashboard3_survive_thrive.png)

The grouped bar chart isolates four key years — 2008, 2009, 2020, 2021 — to show 
how each tier responded to crisis and recovered. The heat map below shows net margin 
by company by year across the full 25-year span, with Ruth's Chris 2020 appearing as 
a vivid red against an otherwise blue field — the sharpest single data point in 
the dataset.

---

## SQL Queries

Eight documented queries in [`restaurant_analysis_queries.sql`](restaurant_analysis_queries.sql):

| Query | Description |
|---|---|
| 1 | Sanity check — verify joins across all three tables |
| 2 | Average net margin by tier across full dataset |
| 3 | COVID impact by tier — 2019 vs 2020 revenue comparison |
| 4 | Best performing company by average net margin with range |
| 5 | Same store sales by tier during key economic events |
| 6 | Location growth by decade per company |
| 7 | Three-table macro context join — revenue vs inflation vs GDP |
| 8 | Consistency scoring — margin range and years above 8% |

---

## Methodology Notes

- Same store sales for Yum! Brands reflects Taco Bell flagship only
- Same store sales for Brinker reflects Chili's flagship only  
- Same store sales for Darden reflects Olive Garden flagship only
- Labor cost data only available for operator-owned companies — franchise models 
  do not carry food or labor costs on their books directly, inflating their 
  reported net margins relative to operators
- Panera Bread data ends 2016 following JAB Holding private acquisition
- Ruth's Chris data ends 2022 following Dine Brands acquisition
- Yum! Brands 2016 revenue drop reflects Yum! China spinoff, not operational decline
- Darden 2014 revenue drop reflects Red Lobster divestiture

---

## Repository Contents

```
restaurant-industry-analysis/
├── README.md
├── restaurant_analysis_queries.sql
├── Restraunt_25_year_Analysis_CLEAN.xlsx
├── Restaurant_Analysis.twbx
└── images/
    ├── dashboard1_big_picture.png
    ├── dashboard2_four_tiers.png
    └── dashboard3_survive_thrive.png
```
