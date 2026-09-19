/* ============================================================
   CUSTOMER CHURN ANALYSIS PROJECT
   DATABASE: POSTGRESQL
   ============================================================ */


/* ============================================================
   STEP 1: CREATE DATABASE
   ============================================================ */

-- Run this while connected to the default "postgres" database

CREATE DATABASE db_churn;


/* ============================================================
   STEP 2: CONNECT TO db_churn
   ============================================================

   In pgAdmin:

   1. Refresh the Databases section
   2. Find db_churn
   3. Right-click db_churn
   4. Select Query Tool

   Run the remaining SQL inside db_churn.

   ============================================================ */


/* ============================================================
   STEP 3: CREATE STAGING TABLE
   ============================================================

   You can create the table manually or use pgAdmin's
   Import/Export feature.

   The example below assumes the CSV columns have been
   imported into:

       stg_churn

   ============================================================ */


/* ============================================================
   STEP 4: VERIFY THE IMPORT
   ============================================================ */

-- Count imported records
SELECT COUNT(*) AS total_rows
FROM stg_churn;


-- Preview imported data
SELECT *
FROM stg_churn
LIMIT 100;


/* ============================================================
   STEP 5: EXPLORE DISTINCT VALUES
   ============================================================ */


/* ---------- Gender Distribution ---------- */

SELECT
    gender,
    COUNT(*) AS total_count,
    COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM stg_churn) AS percentage
FROM stg_churn
GROUP BY gender
ORDER BY percentage DESC;


/* ---------- Contract Distribution ---------- */

SELECT
    contract,
    COUNT(*) AS total_count,
    COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM stg_churn) AS percentage
FROM stg_churn
GROUP BY contract
ORDER BY percentage DESC;


/* ---------- Customer Status & Revenue ---------- */

SELECT
    customer_status,
    COUNT(*) AS total_count,
    SUM(total_revenue) AS total_revenue,

    SUM(total_revenue) * 100.0 /
        NULLIF(
            (SELECT SUM(total_revenue)
             FROM stg_churn), 0
        ) AS revenue_percentage

FROM stg_churn

GROUP BY customer_status

ORDER BY total_revenue DESC;


/* ---------- State Distribution ---------- */

SELECT
    state,
    COUNT(*) AS total_count,
    COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM stg_churn) AS percentage

FROM stg_churn

GROUP BY state

ORDER BY percentage DESC;


/* ============================================================
   STEP 6: CHECK NULL VALUES
   ============================================================ */

SELECT

    COUNT(*) FILTER (
        WHERE customer_id IS NULL
    ) AS customer_id_null_count,

    COUNT(*) FILTER (
        WHERE gender IS NULL
    ) AS gender_null_count,

    COUNT(*) FILTER (
        WHERE age IS NULL
    ) AS age_null_count,

    COUNT(*) FILTER (
        WHERE married IS NULL
    ) AS married_null_count,

    COUNT(*) FILTER (
        WHERE state IS NULL
    ) AS state_null_count,

    COUNT(*) FILTER (
        WHERE number_of_referrals IS NULL
    ) AS number_of_referrals_null_count,

    COUNT(*) FILTER (
        WHERE tenure_in_months IS NULL
    ) AS tenure_in_months_null_count,

    COUNT(*) FILTER (
        WHERE value_deal IS NULL
    ) AS value_deal_null_count,

    COUNT(*) FILTER (
        WHERE phone_service IS NULL
    ) AS phone_service_null_count,

    COUNT(*) FILTER (
        WHERE multiple_lines IS NULL
    ) AS multiple_lines_null_count,

    COUNT(*) FILTER (
        WHERE internet_service IS NULL
    ) AS internet_service_null_count,

    COUNT(*) FILTER (
        WHERE internet_type IS NULL
    ) AS internet_type_null_count,

    COUNT(*) FILTER (
        WHERE online_security IS NULL
    ) AS online_security_null_count,

    COUNT(*) FILTER (
        WHERE online_backup IS NULL
    ) AS online_backup_null_count,

    COUNT(*) FILTER (
        WHERE device_protection_plan IS NULL
    ) AS device_protection_plan_null_count,

    COUNT(*) FILTER (
        WHERE premium_support IS NULL
    ) AS premium_support_null_count,

    COUNT(*) FILTER (
        WHERE streaming_tv IS NULL
    ) AS streaming_tv_null_count,

    COUNT(*) FILTER (
        WHERE streaming_movies IS NULL
    ) AS streaming_movies_null_count,

    COUNT(*) FILTER (
        WHERE streaming_music IS NULL
    ) AS streaming_music_null_count,

    COUNT(*) FILTER (
        WHERE unlimited_data IS NULL
    ) AS unlimited_data_null_count,

    COUNT(*) FILTER (
        WHERE contract IS NULL
    ) AS contract_null_count,

    COUNT(*) FILTER (
        WHERE paperless_billing IS NULL
    ) AS paperless_billing_null_count,

    COUNT(*) FILTER (
        WHERE payment_method IS NULL
    ) AS payment_method_null_count,

    COUNT(*) FILTER (
        WHERE monthly_charge IS NULL
    ) AS monthly_charge_null_count,

    COUNT(*) FILTER (
        WHERE total_charges IS NULL
    ) AS total_charges_null_count,

    COUNT(*) FILTER (
        WHERE total_refunds IS NULL
    ) AS total_refunds_null_count,

    COUNT(*) FILTER (
        WHERE total_extra_data_charges IS NULL
    ) AS total_extra_data_charges_null_count,

    COUNT(*) FILTER (
        WHERE total_long_distance_charges IS NULL
    ) AS total_long_distance_charges_null_count,

    COUNT(*) FILTER (
        WHERE total_revenue IS NULL
    ) AS total_revenue_null_count,

    COUNT(*) FILTER (
        WHERE customer_status IS NULL
    ) AS customer_status_null_count,

    COUNT(*) FILTER (
        WHERE churn_category IS NULL
    ) AS churn_category_null_count,

    COUNT(*) FILTER (
        WHERE churn_reason IS NULL
    ) AS churn_reason_null_count

FROM stg_churn;


/* ============================================================
   STEP 7: CREATE CLEAN PRODUCTION TABLE
   ============================================================ */

-- Remove the table if it already exists.
-- This allows the script to be run again.

DROP TABLE IF EXISTS prod_churn;


/* ------------------------------------------------------------
   Create production table with cleaned NULL values
   ------------------------------------------------------------ */

CREATE TABLE prod_churn AS

SELECT
    customer_id,
    gender,
    age,
    married,
    state,
    number_of_referrals,
    tenure_in_months,

    COALESCE(value_deal, 'None') AS value_deal,

    phone_service,

    COALESCE(multiple_lines, 'No') AS multiple_lines,

    internet_service,

    COALESCE(internet_type, 'None') AS internet_type,

    COALESCE(online_security, 'No')
        AS online_security,

    COALESCE(online_backup, 'No')
        AS online_backup,

    COALESCE(device_protection_plan, 'No')
        AS device_protection_plan,

    COALESCE(premium_support, 'No')
        AS premium_support,

    COALESCE(streaming_tv, 'No')
        AS streaming_tv,

    COALESCE(streaming_movies, 'No')
        AS streaming_movies,

    COALESCE(streaming_music, 'No')
        AS streaming_music,

    COALESCE(unlimited_data, 'No')
        AS unlimited_data,

    contract,
    paperless_billing,
    payment_method,
    monthly_charge,
    total_charges,
    total_refunds,
    total_extra_data_charges,
    total_long_distance_charges,
    total_revenue,
    customer_status,

    COALESCE(churn_category, 'Others')
        AS churn_category,

    COALESCE(churn_reason, 'Others')
        AS churn_reason

FROM stg_churn;


/* ============================================================
   STEP 8: VERIFY PRODUCTION TABLE
   ============================================================ */

SELECT COUNT(*) AS production_rows
FROM prod_churn;


SELECT *
FROM prod_churn
LIMIT 100;


/* ============================================================
   STEP 9: CREATE CHURN VIEW
   ============================================================ */

DROP VIEW IF EXISTS vw_churn_data;

CREATE VIEW vw_churn_data AS

SELECT *
FROM prod_churn

WHERE customer_status IN ('Churned', 'Stayed');


/* ============================================================
   STEP 10: CREATE JOINED CUSTOMER VIEW
   ============================================================ */

DROP VIEW IF EXISTS vw_join_data;

CREATE VIEW vw_join_data AS

SELECT *
FROM prod_churn

WHERE customer_status = 'Joined';


/* ============================================================
   STEP 11: VERIFY VIEWS
   ============================================================ */

SELECT *
FROM vw_churn_data
LIMIT 100;


SELECT *
FROM vw_join_data
LIMIT 100;


/* ============================================================
   STEP 12: FINAL CUSTOMER STATUS CHECK
   ============================================================ */

SELECT
    customer_status,
    COUNT(*) AS customer_count

FROM prod_churn

GROUP BY customer_status

ORDER BY customer_count DESC;


/* ============================================================
   STEP 13: FINAL NULL CHECK
   ============================================================ */

SELECT
    COUNT(*) FILTER (WHERE value_deal IS NULL)
        AS value_deal_nulls,

    COUNT(*) FILTER (WHERE multiple_lines IS NULL)
        AS multiple_lines_nulls,

    COUNT(*) FILTER (WHERE internet_type IS NULL)
        AS internet_type_nulls,

    COUNT(*) FILTER (WHERE online_security IS NULL)
        AS online_security_nulls,

    COUNT(*) FILTER (WHERE churn_category IS NULL)
        AS churn_category_nulls,

    COUNT(*) FILTER (WHERE churn_reason IS NULL)
        AS churn_reason_nulls

FROM prod_churn;


/* ============================================================
   POSTGRESQL PROJECT COMPLETE
   ============================================================ */
