# ✈️ Boeing 737 Fleet Reliability Dashboard: ATA 32 Landing Gear

[**View Live Interactive Dashboard Here**](https://app.powerbi.com/view?r=eyJrIjoiMTE5MTQ0OTktNThjOS00NTRiLWE2MmMtYjZmYzNkZjZiMDczIiwidCI6ImRjNDliNmQyLTM1ZDQtNDM2Yi04Mzg4LWY1MThkOGRjYzNiZCJ9)

![Dashboard Preview](04_Screenshots/dashboard_main.png)

## 📌 Executive Summary
**The Business Problem:** Airlines suffer massive financial losses from Unscheduled Maintenance and Aircraft On Ground (AOG) events. 
**The Solution:** This project engineers an end-to-end data pipeline to ingest, clean, and analyze 500+ unstructured FAA Service Difficulty Reports (SDRs). By normalizing text-heavy mechanic logs and modeling the data, this dashboard predicts ATA 32 (Landing Gear) component failures to shift maintenance strategies from reactive repairs to proactive resource allocation.

---

## 🔍 Strategic Insights & Business Impact
Data is useless without action. Here is how this dashboard drives operational decisions:

1.  **Avionics vs. Structural Priority:** **57%** of recorded defects are functional/avionics issues (e.g., Proximity Sensors, Switches) rather than structural. **Action:** Reallocate training budgets to avionics troubleshooting to resolve these high-frequency, low-repair-time faults faster.
2.  **Predictive Seasonality:** Brake and Tire assemblies show a **40% failure spike** during summer months (July peak), strongly correlating with ambient temperature rise. **Action:** Pre-position ATA 32 inventory at high-temperature hubs (e.g., PHX, LAS) starting in May to reduce supply chain delays.
3.  **Financial Risk Quantification:** **96%** of reported defects (473 of 491) resulted in immediate grounding (AOG status), with only 4% eligible for Minimum Equipment List (MEL) deferral. **Action:** Validates the ROI of implementing a strict, time-based preventative replacement cycle for retraction actuators.
4.  **Phase of Flight Root Cause:** The highest volume of non-tire defects occurs during the **Climb** phase. **Action:** Focuses engineering audits on retraction actuator stress rather than landing impact forces.

---

## 🛠️ Technical Architecture (Medallion Pipeline)
This project utilizes a two-tier database architecture to ensure zero data loss from messy regulatory files.

### 1. Data Engineering (MySQL)
* **Raw Data Ingestion:** Downloaded raw FAA reports as `.xlsx` and converted to `.csv` for bulk ingestion.
* **Bronze Layer (Staging):** Imported all raw data strictly as `TEXT` to prevent schema crashes from blank strings and dirty mechanic logs.
* **Silver Layer (Production View):** Engineered a dynamic SQL View to cast data types, standardize dates, and convert missing flight times to true `NULL` values (preventing inaccurate 0-hour lifecycle calculations).
* **Business Logic:** Derived the `IsDeferred` AOG status column using text-pattern matching on the `Discrepancy` logs (e.g., filtering for "MEL" or "DEFER").

### 2. Data Modeling & Analytics (Power BI)
* **Star Schema:** Designed a high-performance model connecting the Fact Table (Defects) to Dimension Tables (Date, Monthly Temperature).
* **DAX Engineering:**
    * Calculated `3-Month Moving Average` to smooth daily volatility and expose seasonal trends.
    * Engineered a custom `Risk Index / Severity Score` by weighting failure condition text (`FIRE` = 10, `LEAK` = 5) to prioritize safety-critical events.

---

## 📖 Data Dictionary
Below are the key fields modeled in the final Silver Production View:

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| `UniqueControlNumber` | `VARCHAR` | Unique FAA identifier for the reported defect. |
| `DifficultyDate` | `DATE` | Standardized date the defect occurred. |
| `JASCCode` | `VARCHAR` | Joint Aircraft System/Component Code (correlates to ATA Chapter 32). |
| `PartName` | `VARCHAR` | Normalized component name causing the fault. |
| `AircraftTotalTime` | `INT` | Total airframe flight hours at time of failure (Blanks cast as `NULL`). |
| `Discrepancy` | `TEXT` | Raw, unstructured mechanic log detailing the failure. |
| `IsDeferred` | `VARCHAR` | Calculated KPI indicating if the aircraft was grounded (`No`) or flew under MEL (`Yes`). |
| `Total Risk Index` | `DAX Measure` | Weighted severity score plotted on the X-axis for component prioritization. |

---

## ⚙️ Setup & Reproducibility
To run this pipeline locally:
1.  Ensure MySQL Server is installed and running.
2.  Clone this repository: `git clone https://github.com/MominPathann/Boeing-737-Fleet-Reliability.git`
3.  Open `01_SQL_Scripts/database_setup.sql` in MySQL Workbench.
4.  Execute the **Bronze Layer** DDL to create the staging table.
5.  Import `00_Raw_Data/FAA_SDR_Boeing737_ATA32_2024_2025.csv` into the `bronze_sdr_landing_gear` table using the Table Data Import Wizard.
6.  Execute the **Silver Layer** DDL to create the cleaned production view.
7.  Open `02_PowerBI/Boeing_737_Reliability.pbix` and refresh the data source to connect to your local MySQL instance.

---

### 📬 Contact
* **LinkedIn:** [Momin Khan](https://www.linkedin.com/in/mominpathann/)
* **Portfolio:** [Boeing 737 Fleet Reliability](https://github.com/MominPathann/Boeing-737-Fleet-Reliability)
