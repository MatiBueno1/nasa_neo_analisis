# NASA Near Earth Objects — Detection Bias Analysis

> "Are we detecting more asteroids because space is more dangerous, or because we're better at looking?"

End-to-end data pipeline analyzing 30 years of NASA asteroid data 
to determine whether the rise in Potentially Hazardous Asteroid (PHA) 
detections reflects a real increase in threat — or simply improved 
telescope technology.

---

## Tools Used
- **Python** (requests, pandas, python-dotenv, SQLAlchemy) — data extraction & transformation
- **NASA NeoWs API** — real-time asteroid data source
- **MySQL + DBeaver** — relational database & querying
- **Power BI** — interactive dashboard with DAX measures

---

## Project Structure
nasa-neo-analysis/
├── data/
│   ├── raw/              ← Raw JSON from NASA API (not tracked in Git)
│   └── processed/        ← Clean CSV ready for SQL load
├── notebooks/
│   ├── 01_extraction.ipynb    ← API calls, raw data download
│   └── 02_transformation.ipynb ← Cleaning, type casting, SQL load
├── sql/
│   └── 03_analysis_queries.sql
├── dashboard/
│   └── nasa_neo_analysis.pbix
└── README.md

---

## Glossary
| Term | Definition |
|------|-----------|
| **NEO** | Near Earth Object — any asteroid or comet whose orbit brings it within 1.3 AU of the Sun |
| **PHA** | Potentially Hazardous Asteroid — NEO larger than 140m that passes within 0.05 AU of Earth's orbit |
| **Detection Bias** | Statistical distortion where improved observation capability, not actual increase in events, explains a rise in recorded data |
| **Miss Distance** | The minimum distance between an asteroid and Earth during a close approach, measured in km |
| **AU** | Astronomical Unit — the average distance from Earth to the Sun (~150 million km) |
| **Close Approach** | An event where an asteroid passes within a defined distance of Earth |
| **YOY Growth** | Year Over Year Growth — percentage change in a metric compared to the same period in the previous year |
| **NeoWs** | Near Earth Object Web Service — NASA's public API for asteroid data |
| **Absolute Magnitude** | Measure of an asteroid's brightness, used to estimate its size |
| **Orbital Data** | Mathematical description of an asteroid's path, used to reconstruct past and future positions |

---

## Hypothesis
NASA's historical data shows a dramatic increase in asteroid detections 
since the 1990s. The intuitive read is: *space is becoming more dangerous*.

This project tests a different explanation: **detection bias** — the idea 
that improvements in telescope technology and search programs, not an 
actual increase in asteroids, explain the trend.

**Null hypothesis:** The ratio of Potentially Hazardous Asteroids (PHAs) 
to total detections remains stable over time, suggesting the proportion 
of dangerous objects in near-Earth space hasn't changed.

---

## Historical Context
| Year | Program | Impact |
|------|---------|--------|
| 1998 | Spaceguard Survey | First formal Congressional mandate to find NEOs larger than 1km |
| 2005 | NASA Authorization Act | Congress mandates finding 90% of objects larger than 140m by 2020 |
| 2008 | Catalina Sky Survey | Dedicated full-time NEO telescope, largest historical discoverer |
| 2010 | NEOWISE | Space-based infrared telescope, detects dark asteroids invisible to optical telescopes |
| 2016 | Pan-STARRS | Multi-telescope system, responsible for 35% YOY detection spike |
| 2022 | DART Mission | First planetary defense mission — asteroid deflection test, not a detection program |

---

## Pipeline
1. **Extraction** — Python script calls NASA NeoWs API across 30 years (1995–2024),
   handling rate limits with 0.5s delay between requests (~1,560 API calls)
2. **Transformation** — pandas cleaning: type casting, flattening nested JSON,
   removing duplicates, exporting clean CSV
3. **Load** — SQLAlchemy loads clean DataFrame into MySQL relational model (4 tables)
4. **Analysis** — SQL queries using CTEs, window functions (RANK, LAG, SUM OVER)
5. **Visualization** — Power BI dashboard connected directly to MySQL

---

## Data Model
| Table | Description |
|-------|-------------|
| `close_approaches` | One row per asteroid close approach event (79,439 rows) |
| `yearly_summary` | Aggregated detection metrics per year (1995–2024) |
| `detection_programs` | Manual table: NASA detection program milestones by year |
| `program_impact` | YOY growth analysis per program launch year |

---

## Business Questions Answered
1. Did PHA detection rates increase proportionally with total detections?
2. Did average miss distance change over time, indicating real increased risk?
3. Which NASA programs had the greatest impact on detection growth?
4. What are the closest recorded PHA approaches in history?

---

## Key Findings
- The **PHA ratio remained stable at ~10-14%** across all 30 years —
  the proportion of dangerous objects in near-Earth space never changed
- **Average miss distance stayed flat** despite detection counts more than
  doubling — space didn't become more dangerous
- **Pan-STARRS (2016) drove a 35% YOY detection spike**, the largest single
  program impact on record
- **COVID-19 caused a ~35% drop in detections in 2020**, confirming that
  detection counts are sensitive to Earth-based operational disruptions,
  not space activity
- **(2017 VW13)** recorded the closest PHA approach in the dataset at
  120,162 km — discovered in 2017 but its 2001 flyby was reconstructed
  from orbital data, demonstrating objects can pass undetected for years
- **Pan-STARRS increased detection of smaller, closer objects**, temporarily
  lowering the average miss distance between 2017-2019 — not because space
  became more dangerous, but because the telescope was more sensitive

---

## Hypothesis Result
**Confirmed.** The data supports detection bias as the primary driver
of increased PHA counts. The stable PHA ratio (~10%) and flat miss distance
trends indicate the density of dangerous objects in near-Earth space has
not changed — our ability to find them has.

---

## Data Sources
- [NASA NeoWs API](https://api.nasa.gov) — real asteroid close approach data
- [NASA Planetary Defense](https://www.nasa.gov/planetary-defense) — program history
- [Catalina Sky Survey](https://catalina.lpl.arizona.edu) — discovery statistics
- [NASA NEOWISE](https://www.nasa.gov/neowise) — infrared telescope data