# Olist E-Commerce Order & Delivery Performance Analysis

An exploratory data analysis project examining order trends, delivery performance, order fulfilment statuses, and data quality issues using the Olist Brazilian E-Commerce Orders dataset.

## Project Overview

This project analyses Olist's e-commerce order data to understand how orders progress through the fulfilment process, evaluate delivery performance, identify non-delivered orders, and uncover potential data-quality issues.

The analysis follows a data analytics workflow using **Microsoft Excel, MySQL, and Tableau Public** — from initial data exploration and cleaning to SQL-based validation and interactive dashboard development.

**Current project scope:** This version focuses exclusively on the Olist Orders dataset. Additional datasets will be incorporated in future versions to expand the analysis.

## Business Questions

The project aims to answer the following questions:

- What is the total number of orders, and how are they distributed across different order statuses?
- What proportion of orders were successfully delivered?
- How are non-delivered orders distributed across different statuses?
- How many delivered orders arrived on time versus after the estimated delivery date?
- How have order volumes changed over time?
- How does average delivery time vary across months?
- Are there inconsistencies in the order timestamps that could affect the reliability of the analysis?

## Dataset Overview

**Source:** [Olist Brazilian E-Commerce Public Dataset – Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

The Olist dataset contains approximately 100,000 orders from Brazil's e-commerce marketplace, covering the period from 2016 to 2018.

This project currently uses:

`olist_orders_dataset.csv`

- **Total records:** 99,441
- **Total columns:** 8
- **Time period:** 2016–2018

### Columns Used

| Column | Description |
|---|---|
| order_id | Unique order identifier |
| customer_id | Customer identifier |
| order_status | Current status of the order |
| order_purchase_timestamp | Date and time the order was placed |
| order_approved_at | Date and time the order was approved |
| order_delivered_carrier_date | Date and time the order was handed over to the carrier |
| order_delivered_customer_date | Date and time the order was delivered to the customer |
| order_estimated_delivery_date | Estimated delivery date |

## Tools & Technologies

| Tool | Purpose |
|---|---|
| Microsoft Excel | Initial data exploration, PivotTables, and status-wise analysis |
| MySQL | Data import, cleaning, transformation, validation, and analytical queries |
| Tableau Public | KPI development, visual analysis, and interactive dashboard |
| Git & GitHub | Version control and project documentation |

## Project Workflow

### 1. Data Exploration – Excel

- Explored the original dataset and its structure.
- Analysed order-status distribution using PivotTables.
- Examined missing timestamp values across different order statuses.
- Cross-checked initial findings with SQL results.

### 2. Data Cleaning & Validation – MySQL

- Imported the original CSV into a staging table (`stg_orders`).
- Created a cleaned table (`clean_orders`) with appropriate `DATETIME` data types.
- Handled blank timestamp values by converting them into `NULL`.
- Checked total records, distinct order IDs, and duplicate records.
- Analysed missing values across important timestamp columns.
- Investigated chronological inconsistencies between purchase, approval, carrier handover, and customer delivery timestamps.

### 3. Data Visualisation – Tableau Public

Created KPI calculations and visualisations to analyse order and delivery performance.

The dashboard includes:

**Key Performance Indicators**
- Total Orders
- Delivered Orders
- Delivery Rate
- Cancelled Orders
- Non-Delivered Orders

**Visualisations**
- Order Status Distribution
- Non-Delivered Order Status Distribution
- Monthly Order Trend
- Delivery Performance: On Time, Delayed, and Missing Date
- Average Delivery Time by Month

## Key Findings

### Order & Delivery Overview

| Metric | Result |
|---|---:|
| Total Orders | 99,441 |
| Delivered Orders | 96,478 |
| Delivery Rate | 97.02% |
| Cancelled Orders | 625 |
| Non-Delivered Orders | 2,963 |

### Order Status Distribution

| Order Status | Number of Orders |
|---|---:|
| Delivered | 96,478 |
| Shipped | 1,107 |
| Canceled | 625 |
| Unavailable | 609 |
| Invoiced | 314 |
| Processing | 301 |
| Created | 5 |
| Approved | 2 |
| **Total** | **99,441** |

### Delivery Performance

Among delivered orders:

- **88,644** were delivered on or before the estimated delivery date.
- **7,826** were delivered after the estimated delivery date.
- **8** had missing delivery or estimated delivery timestamps, preventing classification.

The delivery-performance classification excludes non-delivered orders.

### Monthly Trends

- November 2017 recorded the highest monthly order volume in the analysed period.
- December 2016 recorded the lowest monthly order volume.
- September 2016 recorded the highest average delivery time among the months analysed.
- December 2016 recorded the lowest average delivery time.

These observations describe the analysed dataset and should not, by themselves, be interpreted as evidence of recurring seasonal patterns.

## Data Quality Investigation

The project also examined timestamp inconsistencies that could affect delivery-performance analysis.

The following anomalies were identified:

| Data Quality Check | Records Found |
|---|---:|
| Carrier handover before order approval | 1,359 |
| Customer delivery before carrier handover | 23 |
| Customer delivery before purchase | 0 |
| Approval before purchase | 0 |

Further investigation showed that 834 of the 1,359 carrier-before-approval records were concentrated on two approval dates: 24 April 2018 and 5 July 2018.

These records were flagged for investigation rather than automatically corrected or deleted. The available dataset does not establish the underlying cause of these inconsistencies.

## Dashboard

The Tableau dashboard brings together the project's KPIs and visualisations in a single view.

**Dashboard: Olist E-Commerce Order & Delivery Analytics Dashboard**

![Olist E-Commerce Order & Delivery Analytics Dashboard](tableau/Olist_Order_Delivery_Dashboard.png)

**Tableau workbook:** `tableau/Olist_Order_Delivery_Dashboard.twbx`

## Repository Structure

```text
Olist_Ecommerce_Analytics/
│
├── data/
│   ├── raw/
│   │   └── olist_orders_dataset.csv
│   │
│   └── cleaned/
│       └── clean_orders.csv
│
├── sql/
│   ├── 01_orders_import_and_cleaning.sql
│   └── 02_orders_data_quality_checks.sql
│
├── tableau/
│   ├── Olist_Order_Delivery_Dashboard.twbx
│   └── Olist_Order_Delivery_Dashboard.png
│
├── reports/
│   ├── Orders_Data_Quality_Findings.txt
│   └── Orders_Analysis_Report.pdf
│
└── documentation/
    └── Olist_Orders_Excel_MySQL_Worklog.txt
```

*Note: The repository structure reflects the intended project organisation. Files should be added as they are finalised.*

## Limitations

- The current analysis uses only the Orders dataset.
- Revenue, payment behaviour, product performance, seller performance, and customer-level purchasing behaviour are outside the current scope.
- Timestamp inconsistencies are identified and documented, but their underlying causes cannot be confirmed using this dataset alone.
- Delivery performance is calculated only for orders with the required delivery and estimated delivery timestamps.

## Future Scope

The project can be extended by integrating additional Olist datasets:

- **Order Items & Products:** Product-level sales and order composition analysis.
- **Payments:** Payment methods, instalments, and payment-value analysis.
- **Customers:** Customer distribution and purchasing behaviour.
- **Sellers:** Seller-level order and delivery performance.
- **Reviews:** Customer satisfaction and review-score analysis.
- **Geolocation:** Regional order distribution and delivery analysis.

Future versions may also include more advanced SQL analysis, additional Tableau dashboards, and Python-based exploratory analysis.

## Conclusion

This project demonstrates an end-to-end analytical workflow using Excel, MySQL, and Tableau Public. It combines data exploration, SQL-based cleaning and validation, analytical investigation, and dashboard development to derive meaningful insights from e-commerce order data.

The current version establishes a foundation for a broader analysis of Olist's e-commerce operations, with additional datasets and business questions planned for future development.
