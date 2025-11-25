# Boeing-737-Fleet-Reliability
End-to-end ETL and Power BI dashboard analyzing 500+ FAA maintenance reports to identify Boeing 737 fleet reliability trends.


✈️ Boeing 737 Fleet Reliability Dashboard📌 Project OverviewBusiness Problem: Airlines face costly delays due to "Unscheduled Maintenance." The goal of this project was to analyze 500+ FAA Service Difficulty Reports (SDR) to determine which sub-systems of the Landing Gear (ATA Chapter 32) drive the most downtime.The Solution: I engineered an end-to-end data pipeline to ingest raw unstructured text data from the FAA, normalize component names, and visualize reliability trends to drive preventative maintenance strategies.🔍 Key FindingsSensor Failures: 57% of defects are functional/avionics issues (low repair cost, high disruption), specifically Proximity Sensors and Switches.Seasonality: Brakes & Tires show a 40% failure spike in Summer months, correlating strongly with ambient temperature rise (Heat Soak).Operational Impact: 96% of reported defects resulted in AOG (Aircraft on Ground) status, with only 4% eligible for deferral (MEL).Phase Analysis: The highest volume of defects occurs during Climb, pointing to Retraction Actuator stress rather than Landing impact.🛠️ Technical Workflow1. Data Engineering (SQL)Ingestion: Loaded raw FAA CSV data into a local MySQL database.Cleaning: Handled data type inconsistencies (Text vs Int) and Null values in flight hours.Logic: Created a schema to handle 1-to-Many relationships between aircraft tail numbers and failure events.2. Data Modeling (Power BI)Star Schema: Built a data model connecting the Fact Table (Defects) to Dimension Tables (Date, Temperature).DAX Measures:3-Month Moving Average to smooth volatility.AOG Events calculated based on non-deferred status.Risk Index calculated by weighting failure modes (Fire = 10, Leak = 5).3. VisualizationDesigned a grid-layout dashboard mimicking internal aviation software tools.Implemented Drill-Through functionality to audit specific aircraft defect logs.Used Tooltips to reveal operational details (Deferral status) without cluttering the main view.📂 Project Structure00_Raw_Data: Source data file (FAA_SDR_Boeing737_ATA32_2024_2025.xlsx).01_SQL_Scripts: Raw SQL queries used for data cleaning.02_PowerBI: The .pbix file containing the dashboard and data model.03_Case_Study_Report: A comprehensive PDF report detailing the business logic and insights.04_Screenshots: Images used in this README.📸 Operational ViewsThe Data Model (Star Schema)Drill-Through Detail (Defect Log)Tooltip Interaction (Defect Deferral)📬 ContactLinkedIn: [Your LinkedIn Profile Link Here]Portfolio: [Your Portfolio Website/Link Here]
### **Instructions:**
1.  **Copy** the code block above.
2.  **Go to your GitHub repository.**
3.  Click on the `README.md` file.
4.  Click the **Pencil Icon** to edit.
5.  **Paste** the code.
6.  **Replace** `[Your LinkedIn Profile Link Here]` with your actual profile URL.
7.  **Commit changes.**

This README is structured to answer the "So What?" question immediately ("Key Findings") and then prove your skills ("Technical Workflow"). It is the final polish on a job well done.

**Congratulations on completing the project!** You have moved from scattered learning to a deployed, professional portfolio piece. Good luck with the job hunt!
