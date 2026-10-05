# Olist E-Commerce Data Analytics

> End-to-end e-commerce data analytics project using Excel, MySQL, SQL, and Power BI.

## Project Overview

This project analyzes the Olist Brazilian E-Commerce dataset to understand sales performance, customer behavior, product performance, payment patterns, and delivery operations.

The project follows an end-to-end data analytics workflow:

**Data Cleaning → SQL Data Quality Checks → SQL EDA → Power BI Dashboard → Business Insights → Recommendations**

The goal is to transform raw e-commerce data into meaningful business insights that can support better business decision-making.

## Business Problem

E-commerce businesses generate large amounts of data across orders, customers, products, payments, reviews, and delivery operations. However, raw data alone does not provide clear insights into business performance.

This project focuses on analyzing the Olist e-commerce dataset to answer key business questions:

- How are sales performing over time?
- Which product categories generate the most sales?
- Which customer states contribute the most revenue?
- How frequently do customers make repeat purchases?
- How does delivery performance affect customer satisfaction?
- What are the major freight and operational costs?
- Which payment methods are most commonly used?

## Project Objectives

- Clean and prepare raw e-commerce datasets for analysis.
- Perform data quality checks using SQL.
- Analyze sales, orders, customers, products, payments, reviews, and delivery performance.
- Identify important trends and patterns using SQL EDA.
- Build interactive Power BI dashboards for business reporting.
- Identify key business insights from the analysis.
- Provide data-driven recommendations to improve customer retention, sales, delivery performance, and operational efficiency.

## Tools & Technologies

- **Excel** — Data cleaning and preparation
- **MySQL** — Data storage, validation, and querying
- **SQL** — Data quality checks and exploratory data analysis
- **Power BI** — Interactive dashboards and data visualization
- **DAX** — Measures and calculations in Power BI
- **GitHub** — Project documentation and portfolio

## Dataset

The project uses the **Olist Brazilian E-Commerce dataset**, which contains information about orders, customers, products, sellers, payments, reviews, product categories, and geolocation.

The cleaned datasets used in the analysis include:

- Orders
- Order Items
- Customers
- Products
- Sellers
- Payments
- Reviews
- Category Translation
- Geolocation

The dataset contains approximately **100K orders** and **112K order-item records**, providing enough data to analyze sales, customer behavior, product performance, and delivery operations.

## Data Cleaning

The raw datasets were cleaned and prepared in Excel before being imported into MySQL and Power BI.

The main data-cleaning activities included:

- Checked for duplicate records and duplicate IDs.
- Identified and handled missing values.
- Standardized date and timestamp formats.
- Checked numerical columns for invalid or zero values.
- Reviewed categorical values for consistency.
- Translated product category names for analysis.
- Validated the cleaned datasets before importing them into MySQL.
- Preserved the original raw datasets separately from the cleaned datasets.

The cleaned data was then used for SQL validation, exploratory analysis, and Power BI reporting.

## SQL Analysis

After data cleaning, the datasets were imported into MySQL for data validation and exploratory data analysis.

### Data Quality Checks

SQL was used to validate:

- Record counts and duplicate records.
- Missing values.
- Primary and foreign key relationships.
- Orders and order-item relationships.
- Product and seller relationships.
- Payment and review relationships.
- Customer uniqueness and repeat customers.
- Product category translation coverage.

### Exploratory Data Analysis

The SQL EDA covered **45 analytical queries** across areas such as:

- Sales performance
- Order and customer analysis
- Product category performance
- Customer retention
- Review analysis
- Delivery performance
- Freight costs
- Payment methods
- Monthly sales and order trends
- Customer state analysis

## Power BI Dashboard

An interactive Power BI report was created to provide a clear view of business performance and operational trends.

### Dashboard 1 — Executive Overview

The Executive Overview dashboard focuses on overall business performance, including:

- Total Sales
- Total Orders
- Total Customers
- Average Order Value
- Total Items Sold
- Average Review Score
- Average Delivery Days
- Repeat Customer Rate
- Total Freight
- Monthly Sales Trend
- Top Product Categories
- Top Customer States
- Payment Value by Payment Type
- Review Score Distribution
- Delivery Performance

### Dashboard 2 — Customer & Operations Analysis

The second dashboard focuses on customer behavior and operational performance, including:

- Customer Order Frequency
- Monthly Order Volume
- Monthly Average Order Value
- Average Delivery Days by State
- Top States by Delivery Time
- Top States by Freight Cost
- Average Review Score by Payment Type
- Sales by Payment Type

Interactive filters were added for **Order Date** and **Customer State** to allow users to explore the data dynamically.

### Dashboard Screenshots

#### Executive Overview

![Executive Overview Dashboard](05_Screenshots/executive_overview.png)

#### Customer & Operations Analysis

![Customer & Operations Analysis Dashboard](05_Screenshots/customer_operations_analysis.png)

## Key Business Insights

### 1. Customer Retention Opportunity

The business acquired a large customer base, but only a small percentage of customers made repeat purchases.

- Unique customers: **96,096**
- Repeat customers: **2,997**
- Repeat customer rate: **3.12%**

This indicates a significant opportunity to improve customer retention and repeat sales.

### 2. Delivery Performance Affects Customer Satisfaction

Most orders were delivered on time, but late deliveries were associated with lower review scores.

- On-time orders: **88,649**
- Late orders: **7,827**
- On-time rate: **~91.9%**
- Average review score for on-time orders: **4.29**
- Average review score for late orders: **2.57**

Improving delivery reliability could therefore improve customer satisfaction.

### 3. High-Performing Product Categories

Several product categories contribute strongly to overall sales, including:

- Sports & Leisure — **~988K**
- Computers & Accessories — **~912K**
- Furniture & Decor — **~730K**

These categories could be prioritized for inventory planning and promotional campaigns.

### 4. Geographic Sales Concentration

Sales are concentrated across a smaller group of customer states.

This creates opportunities to optimize regional marketing, inventory availability, and logistics based on customer demand.

### 5. Low Basket Size

The average order contains approximately **1.14 items**.

This indicates an opportunity to increase order value through cross-selling, product bundles, and personalized recommendations.

### 6. Significant Freight Cost

- Total sales: **13.59M**
- Total freight cost: **2.25M**
- Freight cost relative to item sales: **~16.6%**

This highlights logistics optimization as an important opportunity for improving operational efficiency.

### 7. Credit Cards Dominate Payment Value

Credit cards represent the largest share of payment value in the analysis.

Maintaining a smooth and reliable card-payment experience should therefore remain an important priority.

### 8. Monthly Demand Variation

Monthly sales and order volume show noticeable variation over time.

Identifying high- and low-demand periods can help the business improve inventory planning, promotional campaigns, and operational capacity.

## Business Recommendations

Based on the analysis, the following actions could help improve business performance:

1. **Improve Customer Retention**
   - Introduce loyalty programs and personalized offers.
   - Use post-purchase campaigns to encourage repeat purchases.
   - Target one-time customers with relevant promotions.

2. **Reduce Late Deliveries**
   - Identify states, sellers, and areas with higher delivery delays.
   - Improve logistics planning and monitor delayed shipments.
   - Focus on improving delivery reliability to increase customer satisfaction.

3. **Increase Average Order Value**
   - Introduce product bundles and cross-selling strategies.
   - Recommend complementary products during the purchasing process.
   - Consider incentives for customers who purchase multiple products.

4. **Optimize Freight Costs**
   - Analyze regions and sellers with higher freight costs.
   - Optimize shipping and fulfillment strategies.
   - Balance cost reduction with delivery quality.

5. **Focus on High-Performing Categories and Regions**
   - Maintain sufficient inventory for high-performing product categories.
   - Prioritize marketing in high-performing customer states.
   - Develop targeted strategies to improve sales in lower-performing regions.
  
## Project Structure

```text
Olist-Ecommerce-Analytics/
├── 1_Raw_Data/
├── 2_Cleaned_Data/
├── 3_SQL/
│   ├── 01_Load_Data.sql
│   ├── 02_Data_Quality_Checks.sql
│   └── 03_SQL_EDA.sql
├── 04_PowerBI/
│   └── Power BI dashboard file retained locally
├── 5_Screenshots/
├── 6_Documentation/
├── README.md
└── .gitignore

## Conclusion

This project demonstrates an end-to-end data analytics workflow using Excel, MySQL, SQL, and Power BI.

The analysis transformed raw e-commerce data into actionable insights related to sales performance, customer retention, product categories, delivery performance, payment behavior, and operational costs.

The Power BI dashboards provide an interactive way to explore the results, while the business insights and recommendations demonstrate how data analysis can support practical business decisions.
