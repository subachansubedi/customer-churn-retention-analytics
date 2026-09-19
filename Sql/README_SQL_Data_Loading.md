SQL Data Loading & ETL
This folder contains the SQL-based data loading and ETL portion of the Customer Churn Analysis project.

Two database implementations are provided:

SQL Server

PostgreSQL

Both scripts follow the same overall ETL process but use database-specific SQL syntax.

📁 Files
SQL/
│
├── README.md
├── 01_Customer_Churn_SQL_Server.sql
└── 02_Customer_Churn_PostgreSQL.sql

1. SQL Server
File:

01_Customer_Churn_SQL_Server.sql

The SQL Server implementation uses Microsoft SQL Server and SQL Server Management Studio (SSMS).

The ETL workflow is:

CSV File
   ↓
stg_Churn
   ↓
Data Exploration
   ↓
NULL Validation
   ↓
Data Cleaning
   ↓
prod_Churn
   ↓
Power BI Views

Main objects created
stg_Churn — staging table containing the imported CSV data

prod_Churn — cleaned production table

vw_ChurnData — Churned and Stayed customers

vw_JoinData — Joined customers

The script also includes queries for:

Checking row counts

Exploring customer distributions

Checking NULL values

Replacing missing categorical values

Creating cleaned production data

Creating views for Power BI

2. PostgreSQL
File:

02_Customer_Churn_PostgreSQL.sql

The PostgreSQL implementation follows the same ETL workflow using PostgreSQL and pgAdmin.

CSV File
   ↓
stg_churn
   ↓
Data Exploration
   ↓
NULL Validation
   ↓
Data Cleaning
   ↓
prod_churn
   ↓
Power BI Views

Main objects created
stg_churn — staging table containing the imported CSV data

prod_churn — cleaned production table

vw_churn_data — Churned and Stayed customers

vw_join_data — Joined customers

The PostgreSQL script uses PostgreSQL-specific syntax where necessary.

For example:

SQL Server:

ISNULL(Value_Deal, 'None')

PostgreSQL:

COALESCE(value_deal, 'None')

Similarly:

SQL Server:

SELECT TOP 100 *
FROM prod_Churn;

PostgreSQL:

SELECT *
FROM prod_churn
LIMIT 100;

3. Why Two SQL Versions?
The two SQL files are alternative implementations of the same ETL process.

The business logic and analytical objectives remain the same, while the SQL syntax and database-specific functionality differ.

                 Customer Churn CSV
                        │
              ┌─────────┴─────────┐
              ↓                   ↓
        SQL Server            PostgreSQL
              │                   │
              ↓                   ↓
         Staging Table       Staging Table
              │                   │
              ↓                   ↓
         Data Cleaning       Data Cleaning
              │                   │
              ↓                   ↓
       Production Table     Production Table
              │                   │
              └─────────┬─────────┘
                        ↓
                    Power BI

This demonstrates how the same data workflow can be implemented using different relational database systems.

4. Power Query Alternative
A separate database is not required to load and transform the CSV for Power BI.

The CSV can be loaded directly into Power BI using Power Query.

The workflow becomes:

CSV File
   ↓
Power Query
   ↓
Data Transformation
   ↓
Power BI Data Model
   ↓
Dashboard

In Power BI Desktop:

Home
  → Get Data
  → Text/CSV
  → Select CSV
  → Transform Data

Power Query can perform many of the same transformation tasks handled by the SQL scripts, including:

Changing data types

Replacing NULL values

Creating conditional columns

Creating age groups

Creating tenure groups

Creating monthly charge ranges

Removing duplicates

Filtering data

Unpivoting service columns

Renaming columns

Therefore, the data-loading stage can be implemented in three ways:

Approach	Source	ETL / Transformation
SQL Server	CSV → SQL Server	SQL
PostgreSQL	CSV → PostgreSQL	SQL
Power Query	CSV → Power BI	Power Query

5. Which Approach Is Used?
The SQL files are included to demonstrate database-based ETL and to show that the project can be implemented using both SQL Server and PostgreSQL.

Power Query provides a simpler alternative when the goal is primarily Power BI analysis and a separate database is not necessary.

The final analytical output can be connected to Power BI regardless of which approach is used.