# bitsom_ba_25071498_fleximart_data_architechture

# FlexiMart Data Architecture Project

**Student Name:** Karishma Patel
**Student ID:** bitsom_ba_25071498
**Email:** karishmapatel7130@gmail.com
**Date:** 08-01-2026

## Project Overview

This project implements an end-to-end data architecture solution for FlexiMart, an e-commerce company. It covers data ingestion through an ETL pipeline, NoSQL analysis using MongoDB for flexible product catalogs, and a dimensional data warehouse using a star schema to support analytical reporting and business insights.

The solution demonstrates how raw operational data can be transformed into clean, structured, and analytics-ready datasets.

## Repository Structure
├── part1-database-etl/
│   ├── etl_pipeline.py
│   ├── schema_documentation.md
│   ├── business_queries.sql
│   └── data_quality_report.txt
├── part2-nosql/
│   ├── nosql_analysis.md
│   ├── mongodb_operations.js
│   └── products_catalog.json
├── part3-datawarehouse/
│   ├── star_schema_design.md
│   ├── warehouse_schema.sql
│   ├── warehouse_data.sql
│   └── analytics_queries.sql
└── README.md

## Technologies Used

- Python 3.x (pandas, mysql-connector-python)
- MySQL 8.0 / PostgreSQL 14
- MongoDB 6.0
- SQL & NoSQL (MongoDB)
- Dimensional Modeling (Star Schema)


## Setup Instructions

### Database Setup

```bash
# Create databases
mysql -u root -p -e "CREATE DATABASE fleximart;"
mysql -u root -p -e "CREATE DATABASE fleximart_dw;"

# Run Part 1 - ETL Pipeline
python part1-database-etl/etl_pipeline.py

# Run Part 1 - Business Queries
mysql -u root -p fleximart < part1-database-etl/business_queries.sql

# Run Part 3 - Data Warehouse
mysql -u root -p fleximart_dw < part3-datawarehouse/warehouse_schema.sql
mysql -u root -p fleximart_dw < part3-datawarehouse/warehouse_data.sql
mysql -u root -p fleximart_dw < part3-datawarehouse/analytics_queries.sql


### MongoDB Setup

mongosh < part2-nosql/mongodb_operations.js

## Key Learnings

Through this project, I gained hands-on experience in building a complete data pipeline from raw source data to analytical reporting. I learned how to design and implement ETL processes, handle real-world data quality issues, and apply dimensional modeling concepts using a star schema. The project also strengthened my understanding of when to use relational databases versus NoSQL databases like MongoDB for flexible data structures. Additionally, writing analytical SQL queries helped translate business requirements into actionable insights.

## Challenges Faced

Handling inconsistent and missing data in raw CSV files
Solution: Applied appropriate data cleaning strategies such as deduplication, null handling, and standardization during the ETL process.

Designing a correct star schema with proper granularity
Solution: Clearly defined the fact table grain at the transaction line-item level and used surrogate keys to ensure scalability and analytical flexibility.

