/* ============================================================
   CUSTOMER CHURN ANALYSIS PROJECT
   DATABASE: SQL SERVER
   ============================================================ */


/* ============================================================
   STEP 1: CREATE DATABASE
   ============================================================ */

-- Create the churn database
CREATE DATABASE db_Churn;
GO


/* ============================================================
   STEP 2: USE THE DATABASE
   ============================================================ */

USE db_Churn;
GO


/* ============================================================
   STEP 3: IMPORT CSV INTO STAGING TABLE
   ============================================================

   Use SSMS:

   Right-click db_Churn
       -> Tasks
       -> Import Flat File

   Import the CSV as:

       dbo.stg_Churn

   Recommended:
       Customer_ID = Primary Key

   Allow NULL values during import.

   If the Import Wizard has problems with BIT columns,
   import those columns as VARCHAR(50).

   ============================================================ */


/* ============================================================
   STEP 4: VERIFY THE IMPORT
   ============================================================ */

-- Count imported records
SELECT COUNT(*) AS Total_Rows
FROM dbo.stg_Churn;

-- Preview the data
SELECT TOP 100 *
FROM dbo.stg_Churn;


/* ============================================================
   STEP 5: EXPLORE DISTINCT VALUES
   ============================================================ */


/* ---------- Gender Distribution ---------- */

SELECT
    Gender,
    COUNT(*) AS TotalCount,
    COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM dbo.stg_Churn) AS Percentage
FROM dbo.stg_Churn
GROUP BY Gender
ORDER BY Percentage DESC;


/* ---------- Contract Distribution ---------- */

SELECT
    Contract,
    COUNT(*) AS TotalCount,
    COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM dbo.stg_Churn) AS Percentage
FROM dbo.stg_Churn
GROUP BY Contract
ORDER BY Percentage DESC;


/* ---------- Customer Status & Revenue ---------- */

SELECT
    Customer_Status,
    COUNT(*) AS TotalCount,
    SUM(Total_Revenue) AS Total_Revenue,
    SUM(Total_Revenue) * 100.0 /
        NULLIF(
            (SELECT SUM(Total_Revenue)
             FROM dbo.stg_Churn), 0
        ) AS Revenue_Percentage
FROM dbo.stg_Churn
GROUP BY Customer_Status
ORDER BY Total_Revenue DESC;


/* ---------- State Distribution ---------- */

SELECT
    State,
    COUNT(*) AS TotalCount,
    COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM dbo.stg_Churn) AS Percentage
FROM dbo.stg_Churn
GROUP BY State
ORDER BY Percentage DESC;


/* ============================================================
   STEP 6: CHECK NULL VALUES
   ============================================================ */

SELECT

    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END)
        AS Customer_ID_Null_Count,

    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END)
        AS Gender_Null_Count,

    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END)
        AS Age_Null_Count,

    SUM(CASE WHEN Married IS NULL THEN 1 ELSE 0 END)
        AS Married_Null_Count,

    SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END)
        AS State_Null_Count,

    SUM(CASE WHEN Number_of_Referrals IS NULL THEN 1 ELSE 0 END)
        AS Number_of_Referrals_Null_Count,

    SUM(CASE WHEN Tenure_in_Months IS NULL THEN 1 ELSE 0 END)
        AS Tenure_in_Months_Null_Count,

    SUM(CASE WHEN Value_Deal IS NULL THEN 1 ELSE 0 END)
        AS Value_Deal_Null_Count,

    SUM(CASE WHEN Phone_Service IS NULL THEN 1 ELSE 0 END)
        AS Phone_Service_Null_Count,

    SUM(CASE WHEN Multiple_Lines IS NULL THEN 1 ELSE 0 END)
        AS Multiple_Lines_Null_Count,

    SUM(CASE WHEN Internet_Service IS NULL THEN 1 ELSE 0 END)
        AS Internet_Service_Null_Count,

    SUM(CASE WHEN Internet_Type IS NULL THEN 1 ELSE 0 END)
        AS Internet_Type_Null_Count,

    SUM(CASE WHEN Online_Security IS NULL THEN 1 ELSE 0 END)
        AS Online_Security_Null_Count,

    SUM(CASE WHEN Online_Backup IS NULL THEN 1 ELSE 0 END)
        AS Online_Backup_Null_Count,

    SUM(CASE WHEN Device_Protection_Plan IS NULL THEN 1 ELSE 0 END)
        AS Device_Protection_Plan_Null_Count,

    SUM(CASE WHEN Premium_Support IS NULL THEN 1 ELSE 0 END)
        AS Premium_Support_Null_Count,

    SUM(CASE WHEN Streaming_TV IS NULL THEN 1 ELSE 0 END)
        AS Streaming_TV_Null_Count,

    SUM(CASE WHEN Streaming_Movies IS NULL THEN 1 ELSE 0 END)
        AS Streaming_Movies_Null_Count,

    SUM(CASE WHEN Streaming_Music IS NULL THEN 1 ELSE 0 END)
        AS Streaming_Music_Null_Count,

    SUM(CASE WHEN Unlimited_Data IS NULL THEN 1 ELSE 0 END)
        AS Unlimited_Data_Null_Count,

    SUM(CASE WHEN Contract IS NULL THEN 1 ELSE 0 END)
        AS Contract_Null_Count,

    SUM(CASE WHEN Paperless_Billing IS NULL THEN 1 ELSE 0 END)
        AS Paperless_Billing_Null_Count,

    SUM(CASE WHEN Payment_Method IS NULL THEN 1 ELSE 0 END)
        AS Payment_Method_Null_Count,

    SUM(CASE WHEN Monthly_Charge IS NULL THEN 1 ELSE 0 END)
        AS Monthly_Charge_Null_Count,

    SUM(CASE WHEN Total_Charges IS NULL THEN 1 ELSE 0 END)
        AS Total_Charges_Null_Count,

    SUM(CASE WHEN Total_Refunds IS NULL THEN 1 ELSE 0 END)
        AS Total_Refunds_Null_Count,

    SUM(CASE WHEN Total_Extra_Data_Charges IS NULL THEN 1 ELSE 0 END)
        AS Total_Extra_Data_Charges_Null_Count,

    SUM(CASE WHEN Total_Long_Distance_Charges IS NULL THEN 1 ELSE 0 END)
        AS Total_Long_Distance_Charges_Null_Count,

    SUM(CASE WHEN Total_Revenue IS NULL THEN 1 ELSE 0 END)
        AS Total_Revenue_Null_Count,

    SUM(CASE WHEN Customer_Status IS NULL THEN 1 ELSE 0 END)
        AS Customer_Status_Null_Count,

    SUM(CASE WHEN Churn_Category IS NULL THEN 1 ELSE 0 END)
        AS Churn_Category_Null_Count,

    SUM(CASE WHEN Churn_Reason IS NULL THEN 1 ELSE 0 END)
        AS Churn_Reason_Null_Count

FROM dbo.stg_Churn;


/* ============================================================
   STEP 7: CREATE CLEAN PRODUCTION TABLE
   ============================================================ */

-- Delete existing table if running the script again
IF OBJECT_ID('dbo.prod_Churn', 'U') IS NOT NULL
    DROP TABLE dbo.prod_Churn;
GO


-- Create cleaned production table
SELECT
    Customer_ID,
    Gender,
    Age,
    Married,
    State,
    Number_of_Referrals,
    Tenure_in_Months,

    ISNULL(Value_Deal, 'None') AS Value_Deal,

    Phone_Service,

    ISNULL(Multiple_Lines, 'No') AS Multiple_Lines,

    Internet_Service,

    ISNULL(Internet_Type, 'None') AS Internet_Type,

    ISNULL(Online_Security, 'No') AS Online_Security,

    ISNULL(Online_Backup, 'No') AS Online_Backup,

    ISNULL(Device_Protection_Plan, 'No')
        AS Device_Protection_Plan,

    ISNULL(Premium_Support, 'No')
        AS Premium_Support,

    ISNULL(Streaming_TV, 'No')
        AS Streaming_TV,

    ISNULL(Streaming_Movies, 'No')
        AS Streaming_Movies,

    ISNULL(Streaming_Music, 'No')
        AS Streaming_Music,

    ISNULL(Unlimited_Data, 'No')
        AS Unlimited_Data,

    Contract,
    Paperless_Billing,
    Payment_Method,
    Monthly_Charge,
    Total_Charges,
    Total_Refunds,
    Total_Extra_Data_Charges,
    Total_Long_Distance_Charges,
    Total_Revenue,
    Customer_Status,

    ISNULL(Churn_Category, 'Others')
        AS Churn_Category,

    ISNULL(Churn_Reason, 'Others')
        AS Churn_Reason

INTO dbo.prod_Churn

FROM dbo.stg_Churn;
GO


/* ============================================================
   STEP 8: VERIFY CLEAN DATA
   ============================================================ */

SELECT COUNT(*) AS Production_Rows
FROM dbo.prod_Churn;

SELECT TOP 100 *
FROM dbo.prod_Churn;


/* ============================================================
   STEP 9: CREATE CHURN VIEW
   ============================================================ */

CREATE OR ALTER VIEW dbo.vw_ChurnData
AS
SELECT *
FROM dbo.prod_Churn
WHERE Customer_Status IN ('Churned', 'Stayed');
GO


/* ============================================================
   STEP 10: CREATE JOINED CUSTOMER VIEW
   ============================================================ */

CREATE OR ALTER VIEW dbo.vw_JoinData
AS
SELECT *
FROM dbo.prod_Churn
WHERE Customer_Status = 'Joined';
GO


/* ============================================================
   STEP 11: VERIFY VIEWS
   ============================================================ */

SELECT *
FROM dbo.vw_ChurnData;

SELECT *
FROM dbo.vw_JoinData;


/* ============================================================
   STEP 12: FINAL CUSTOMER STATUS CHECK
   ============================================================ */

SELECT
    Customer_Status,
    COUNT(*) AS Customer_Count
FROM dbo.prod_Churn
GROUP BY Customer_Status
ORDER BY Customer_Count DESC;


/* ============================================================
   SQL SERVER PROJECT COMPLETE
   ============================================================ */
