Automated Monthly Marketing Performance Reporting & Power BI Dashboard
Project Overview

This project automates the monthly marketing reporting process by combining campaign, conversion, and customer data into a structured reporting workflow.

The project uses PostgreSQL, Python, and Power BI to clean, validate, transform, analyse, and visualise marketing performance data. It helps stakeholders monitor important KPIs such as campaign spend, conversions, revenue, CAC, ROAS, and customer acquisition trends.

Business Problem

Marketing teams often prepare monthly reports manually by combining data from multiple files. This process can be:

Time-consuming
Repetitive
Prone to calculation errors
Difficult to validate
Hard to scale as data volume increases

This project creates a repeatable reporting workflow that reduces manual effort and provides a consistent view of campaign performance.

Project Objectives
Combine campaign, conversion, and customer datasets
Clean and validate raw marketing data
Create SQL-based reporting tables
Calculate important marketing KPIs
Identify high- and low-performing campaigns
Analyse customer acquisition trends
Build an interactive Power BI dashboard
Create a reusable monthly reporting process
Tools and Technologies
PostgreSQL – Data storage, transformation, joins, aggregations, and KPI calculations
SQL – Data cleaning, validation, reporting queries, CTEs, joins, and window functions
Python – Additional validation, reporting preparation, and automation support
Pandas – Data manipulation and quality checks
Power BI – Dashboard creation and KPI reporting
DAX – Measures and calculated business metrics
Excel/CSV – Source data files
GitHub – Project documentation and version control
Dataset Description

The project uses three main datasets:

1. Campaign Data

Contains campaign-level marketing information.

Example fields:

Campaign ID
Campaign Name
Marketing Channel
Campaign Start Date
Campaign End Date
Campaign Spend
Impressions
Clicks
2. Conversion Data

Contains conversion and revenue information generated from marketing campaigns.

Example fields:

Conversion ID
Campaign ID
Customer ID
Conversion Date
Conversion Type
Revenue
Order Value
3. Customer Data

Contains customer acquisition and segmentation information.

Example fields:

Customer ID
Customer Name
Acquisition Date
Acquisition Channel
Customer Segment
City
Customer Status
Project Workflow
Raw CSV Files
      ↓
Data Validation and Cleaning
      ↓
PostgreSQL Database
      ↓
SQL Data Transformation
      ↓
Monthly Reporting Tables
      ↓
Power BI Data Model
      ↓
Interactive Marketing Dashboard
      ↓
Business Insights and Recommendations
Data Cleaning and Validation

The following checks were performed before analysis:

Removed duplicate records
Handled missing values
Standardised date formats
Checked campaign and customer IDs
Validated numeric columns
Identified invalid or negative values
Verified relationships between datasets
Checked campaigns without conversions
Checked conversions without valid campaigns
Standardised channel and campaign names
Validated monthly totals
SQL Analysis

SQL was used to create a structured reporting layer from the raw datasets.

Key SQL tasks included:

Creating database tables
Importing CSV data
Joining campaign, conversion, and customer tables
Calculating monthly campaign performance
Aggregating spend, conversions, and revenue
Creating channel-level reports
Identifying top-performing campaigns
Comparing campaign performance across months
Analysing customer acquisition
Creating reusable reporting views
Performing data quality checks
Key Performance Indicators

The dashboard tracks the following KPIs:

Total Campaign Spend
Total Campaign Spend = Sum of campaign marketing spend
Total Conversions
Total Conversions = Count of completed conversions
Total Revenue
Total Revenue = Sum of revenue generated from conversions
Customer Acquisition Cost
CAC = Total Campaign Spend / New Customers Acquired
Return on Ad Spend
ROAS = Total Revenue / Total Campaign Spend
Conversion Rate
Conversion Rate = Total Conversions / Total Clicks
Click-Through Rate
CTR = Total Clicks / Total Impressions
Cost per Conversion
Cost per Conversion = Total Campaign Spend / Total Conversions
Average Order Value
Average Order Value = Total Revenue / Total Conversions
New Customers
New Customers = Customers acquired during the selected reporting period
Power BI Dashboard

The Power BI dashboard provides an interactive view of monthly marketing performance.

Page 1: Executive Overview

This page gives stakeholders a high-level summary of overall campaign performance.

Visuals include:

Total Campaign Spend
Total Revenue
Total Conversions
ROAS
CAC
Conversion Rate
Monthly revenue trend
Spend versus revenue comparison
Performance by marketing channel
Campaign performance summary
Page 2: Campaign and Channel Analysis

This page provides a detailed breakdown of campaign performance.

Visuals include:

Campaign-wise spend
Campaign-wise conversions
Campaign-wise revenue
ROAS by campaign
CAC by campaign
Channel performance comparison
Top-performing campaigns
Low-performing campaigns
Monthly campaign trends
Page 3: Customer Acquisition Analysis

This page focuses on customer growth and acquisition performance.

Visuals include:

New customers by month
Customers by acquisition channel
Customer segment distribution
Acquisition trend
Revenue by customer segment
Customer status analysis
Channel-wise customer acquisition cost
Dashboard Filters

The report contains interactive slicers for:

Reporting Month
Campaign Name
Marketing Channel
Customer Segment
Customer Status
City
Conversion Type

These filters allow users to analyse performance for specific campaigns, channels, time periods, and customer groups.

Data Model

The Power BI data model connects the main datasets using shared identifiers.

Campaigns
   |
   | Campaign ID
   |
Conversions
   |
   | Customer ID
   |
Customers

Main relationships:

One campaign can generate multiple conversions
One customer can complete multiple conversions
Campaign ID connects campaign and conversion data
Customer ID connects customer and conversion data
Example Business Questions Answered

The project helps answer questions such as:

Which marketing channel generates the highest revenue?
Which campaign has the highest ROAS?
Which campaigns have high spend but low conversions?
How is campaign performance changing month over month?
What is the average customer acquisition cost?
Which customer segment generates the most revenue?
Which channels acquire the highest number of customers?
Which campaigns should receive more budget?
Where should marketing spend be reduced?
Are monthly campaign results meeting performance expectations?
Key Insights Generated

The dashboard can help identify:

High-performing marketing channels
Campaigns producing strong returns
Campaigns with inefficient spending
Changes in monthly conversion performance
Customer segments contributing the most revenue
Channels with high acquisition costs
Opportunities for budget reallocation
Campaigns requiring optimisation

The exact insights depend on the selected reporting period and dashboard filters.

Business Recommendations

Based on the analysis, marketing teams can:

Increase budget for campaigns with consistently high ROAS
Reduce or optimise spending on campaigns with low conversion rates
Focus on channels with lower customer acquisition costs
Improve targeting for underperforming customer segments
Monitor monthly KPI changes to detect performance issues early
Use standardised reporting tables for faster decision-making
Automate recurring reporting activities to reduce manual work
Project Folder Structure
Automated-Monthly-Marketing-Reporting/
│
├── data/
│   ├── raw_campaigns.csv
│   ├── raw_conversions.csv
│   └── raw_customers.csv
│
├── sql/
│   └── marketing_reporting_analysis.sql
│
├── python/
│   └── monthly_reporting_automation.ipynb
│
├── dashboard/
│   └── marketing_performance_dashboard.pbix
│
├── images/
│   ├── executive_overview.png
│   ├── campaign_analysis.png
│   └── customer_analysis.png
│
└── README.md
How to Run the Project
1. Clone the Repository
git clone https://github.com/your-username/automated-monthly-marketing-reporting.git
2. Create the PostgreSQL Database

Create a new PostgreSQL database for the project.

CREATE DATABASE marketing_reporting;
3. Run the SQL File

Execute the SQL script available in the sql folder.

The script will:

Create the required tables
Import or prepare the source data
Clean and transform the data
Generate monthly reporting outputs
Calculate marketing KPIs
4. Run the Python Notebook

Open the notebook in Google Colab or Jupyter Notebook.

The notebook can be used for:

Data validation
Additional data cleaning
Monthly file preparation
Exporting dashboard-ready data
5. Open the Power BI Dashboard

Open the .pbix file available in the dashboard folder.

Update the data source path if required and refresh the report.

Project Deliverables
Three realistic marketing datasets
PostgreSQL database structure
SQL data-cleaning queries
SQL KPI calculations
Monthly reporting tables
Python validation workflow
Interactive Power BI dashboard
Business insights and recommendations
Complete GitHub documentation
Skills Demonstrated
SQL querying
PostgreSQL database management
Data cleaning and transformation
Data validation
Relational data modelling
Marketing analytics
Campaign performance analysis
KPI development
Customer acquisition analysis
Reporting automation
Power BI dashboard development
DAX measures
Business insight generation
Data storytelling
Documentation
Future Improvements
Connect Power BI directly to PostgreSQL
Schedule automatic monthly data refreshes
Add email-based report distribution
Create campaign-performance alerts
Add budget forecasting
Include campaign targets versus actual performance
Build predictive models for conversion probability
Add customer lifetime value analysis
Deploy the reporting workflow using cloud services
Dashboard Preview

Add screenshots of the completed Power BI dashboard here.

![Executive Overview](images/executive_overview.png)

![Campaign Analysis](images/campaign_analysis.png)

![Customer Acquisition Analysis](images/customer_analysis.png)
Conclusion

This project demonstrates how raw marketing data can be transformed into a structured and reusable monthly reporting system.

By combining PostgreSQL, SQL, Python, and Power BI, the project reduces manual reporting effort, improves data consistency, and provides actionable insights into campaign performance, customer acquisition, marketing efficiency, and revenue generation.

Author

Krishna Rathi

Data Analyst
Skills: SQL, Python, Excel, PostgreSQL and Power BI
GitHub: (https://github.com/krishnar811)
LinkedIn: www.linkedin.com/in/rathi-krishnaa
