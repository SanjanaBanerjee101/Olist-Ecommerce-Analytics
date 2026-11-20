
CREATE DATABASE olist_analytics;

USE olist_analytics;

-- 1.VERIFY TOTAL RECORDS
SELECT COUNT(*) AS total_orders
FROM olist_orders_dataset;

-- 2.CHECK COLUMN STRUCTURE
DESCRIBE olist_orders_dataset;

-- 3.CHECK SAMPLE DATASET
SELECT * 
FROM olist_orders_dataset
LIMIT 10;

-- 4. CREATING THE CLEANED DATASET TABLE
CREATE TABLE clean_orders AS
SELECT
	order_id,
    customer_id,
    order_status,
    
    STR_TO_DATE(
        NULLIF(TRIM(order_purchase_timestamp), ''),
        '%Y-%m-%d %H:%i:%s'
    ) AS order_purchase_timestamp,

    STR_TO_DATE(
        NULLIF(TRIM(order_approved_at), ''),
        '%Y-%m-%d %H:%i:%s'
    ) AS order_approved_at,

    STR_TO_DATE(
        NULLIF(TRIM(order_delivered_carrier_date), ''),
        '%Y-%m-%d %H:%i:%s'
    ) AS order_delivered_carrier_date,

    STR_TO_DATE(
        NULLIF(TRIM(order_delivered_customer_date), ''),
        '%Y-%m-%d %H:%i:%s'
    ) AS order_delivered_customer_date,

    STR_TO_DATE(
        NULLIF(TRIM(order_estimated_delivery_date), ''),
        '%Y-%m-%d %H:%i:%s'
    ) AS order_estimated_delivery_date

FROM olist_orders_dataset;

-- 5.Check row count
SELECT COUNT(*) FROM clean_orders;

-- 6.Check column data types
DESCRIBE clean_orders;

-- 7.Inspect converted timestamps
SELECT
    order_id,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_customer_date
FROM clean_orders
LIMIT 10;

-- 8.CHECKING FOR DUPLICATE RECORDS
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT order_id) AS unique_order_ids
FROM clean_orders;

-- 9.SELECTING THE RECORDS OCCURING MORE THAN ONCE
SELECT
    order_id,
    COUNT(*) AS occurrence_count
FROM clean_orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- 10.MISSING VALUES

SELECT
    COUNT(*) AS total_records,

    SUM(order_id IS NULL) AS missing_order_id,
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(order_status IS NULL) AS missing_order_status,

    SUM(order_purchase_timestamp IS NULL) AS missing_purchase_date,
    SUM(order_approved_at IS NULL) AS missing_approval_date,
    SUM(order_delivered_carrier_date IS NULL) AS missing_carrier_date,
    SUM(order_delivered_customer_date IS NULL) AS missing_delivery_date,
    SUM(order_estimated_delivery_date IS NULL) AS missing_estimated_date

FROM clean_orders;

-- 11. LOOKING FOR ANOMALIES
SELECT
    order_status,
    COUNT(*) AS total_orders,

    SUM(order_approved_at IS NULL) AS missing_approval,
    SUM(order_delivered_carrier_date IS NULL) AS missing_carrier,
    SUM(order_delivered_customer_date IS NULL) AS missing_delivery

FROM clean_orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- 12.INVESTIGATING THE ANOMALIES

SELECT
    order_id,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM clean_orders
WHERE order_status = 'delivered'
AND (
    order_approved_at IS NULL
    OR order_delivered_carrier_date IS NULL
    OR order_delivered_customer_date IS NULL
);

SELECT
    COUNT(*) AS total_anomalous_delivered_orders
FROM clean_orders
WHERE order_status = 'delivered'
AND (
    order_approved_at IS NULL
    OR order_delivered_carrier_date IS NULL
    OR order_delivered_customer_date IS NULL
);


SELECT
    COUNT(*) AS canceled_orders_with_delivery_dates
FROM clean_orders
WHERE order_status = 'canceled'
AND order_delivered_customer_date IS NOT NULL;

SELECT
    order_id,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM clean_orders
WHERE order_status = 'canceled'
AND (
    order_delivered_customer_date IS NOT NULL
);


-- 13. CHECKING THE TIMESTAMP CHRONOLOGY

SELECT
    'Approval before purchase' AS anomaly_type,
    COUNT(*) AS anomaly_count
FROM clean_orders
WHERE order_approved_at IS NOT NULL
  AND order_approved_at < order_purchase_timestamp

UNION ALL

SELECT
    'Carrier handover before approval',
    COUNT(*)
FROM clean_orders
WHERE order_approved_at IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_carrier_date < order_approved_at

UNION ALL

SELECT
    'Customer delivery before carrier handover',
    COUNT(*)
FROM clean_orders
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date < order_delivered_carrier_date

UNION ALL

SELECT
    'Customer delivery before purchase',
    COUNT(*)
FROM clean_orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date < order_purchase_timestamp;
 
 
 -- 14.INVESTIGATING TIMESTAMP ANOMALIES
 
SELECT
    order_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date
FROM clean_orders
WHERE order_approved_at IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_carrier_date < order_approved_at
ORDER BY order_delivered_carrier_date;


SELECT
    DATE(order_approved_at) AS approval_date,
    COUNT(*) AS anomaly_count
FROM clean_orders
WHERE order_approved_at IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_carrier_date < order_approved_at
GROUP BY DATE(order_approved_at)
ORDER BY anomaly_count DESC;



SELECT
    DATE(order_approved_at) AS approval_date,
    DATE(order_delivered_carrier_date) AS carrier_date,
    COUNT(*) AS affected_orders
FROM clean_orders
WHERE order_approved_at IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_carrier_date < order_approved_at
  AND DATE(order_approved_at) IN ('2018-07-05', '2018-04-24')
GROUP BY
    DATE(order_approved_at),
    DATE(order_delivered_carrier_date)
ORDER BY
    approval_date,
    affected_orders DESC;


SELECT
    order_status,
    COUNT(*) AS affected_orders
FROM clean_orders
WHERE order_approved_at IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_carrier_date < order_approved_at
GROUP BY order_status
ORDER BY affected_orders DESC;


SELECT
    CASE
        WHEN TIMESTAMPDIFF(
            HOUR,
            order_delivered_carrier_date,
            order_approved_at
        ) <= 1 THEN 'Up to 1 hour'

        WHEN TIMESTAMPDIFF(
            HOUR,
            order_delivered_carrier_date,
            order_approved_at
        ) <= 6 THEN '1-6 hours'

        WHEN TIMESTAMPDIFF(
            HOUR,
            order_delivered_carrier_date,
            order_approved_at
        ) <= 24 THEN '6-24 hours'

        WHEN TIMESTAMPDIFF(
            HOUR,
            order_delivered_carrier_date,
            order_approved_at
        ) <= 48 THEN '1-2 days'

        ELSE 'More than 2 days'
    END AS time_difference,

    COUNT(*) AS affected_orders

FROM clean_orders

WHERE order_approved_at IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_carrier_date < order_approved_at

GROUP BY time_difference
ORDER BY MIN(
    TIMESTAMPDIFF(
        HOUR,
        order_delivered_carrier_date,
        order_approved_at
    )
);



SELECT
    order_status,
    COUNT(*) AS affected_orders,
    AVG(
        TIMESTAMPDIFF(
            HOUR,
            order_delivered_customer_date,
            order_delivered_carrier_date
        )
    ) AS avg_hours_difference
FROM clean_orders
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date < order_delivered_carrier_date
GROUP BY order_status;
