training-datasets
This repository is a collection of realistic, structured datasets designed for educational and professional training purposes in the field of data analytics, data warehousing, and business intelligence. Each dataset is sourced or built for a specific industry and includes a raw data component as well as a pre-designed dimensional model (star or snowflake schema) to facilitate hands-on learning.

Project Goals
The primary goal of this project is to provide a standardized, high-quality resource for practicing essential data skills, including:

ETL/ELT processes: Extracting, transforming, and loading data into a structured format.

Dimensional Modeling: Designing and implementing star and snowflake schemas.

SQL and Query Optimization: Writing complex queries against large datasets.

Business Intelligence: Creating reports and dashboards from a modeled data warehouse.

Performance Tuning: Working with large datasets to understand query performance.

Repository Structure
The repository is organized by industry. Each industry folder contains a complete, self-contained dataset with the following structure:



Datasets
Each dataset has been carefully curated to meet the following criteria:

Size: A total of at least 1 million rows across all tables.

Complexity: A minimum of 5 interconnected tables.

Realism: Contains realistic data points, relationships, and potential data quality challenges common to the industry.

Currently available datasets:

Industry

Description

Model Type

Logistics

Simulates supply chain operations, including shipments, routes, and warehouses.

Star Schema

Oil & Gas

Models exploration and production data, including well performance and operational metrics.

Snowflake Schema

Telecom

Tracks customer usage, billing, and network performance data.

Star Schema

Data Dictionary
A data_dictionary.md file is included in each industry folder. This document provides essential metadata for all tables and columns, including:

Table and column names

Data types

Descriptions of the data

Relationships between tables (e.g., primary and foreign keys)

Sample values

How to Use
To use these datasets, you can:

Clone the repository: git clone https://github.com/your-username/training-datasets.git

Load the data: Import the .csv files into your preferred database (e.g., PostgreSQL, MySQL, SQL Server) using a tool like psql, mysql, or a data loading library in Python.

Explore the data: Use the provided data dictionary to understand the schema and relationships.

Practice: Write queries, build dashboards, and experiment with different modeling techniques.

Contributing
We welcome contributions! If you have a realistic dataset for a new industry or an improvement to an existing one, please feel free to open a pull request. Contributions should include:

A new folder for the industry.

Realistic raw data (≥ 5 tables, ≥ 1M rows total).

A corresponding dimensional model (star or snowflake).

A complete data_dictionary.md file.

Please review the existing datasets to ensure your contribution follows the established format.

License
This project is licensed under the MIT License.
