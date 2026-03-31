
SELECT
    DATA:"warehouse_id"::STRING        AS WAREHOUSE_ID,
    DATA:"product_id"::STRING          AS PRODUCT_ID,
    DATA:"quantity_available"::NUMBER  AS QUANTITY_AVAILABLE,
    DATA:"reorder_threshold"::NUMBER   AS REORDER_THRESHOLD,
    DATA:"snapshot_date"::DATE         AS SNAPSHOT_DATE
FROM SUPPLYCHAIN360_DB.RAW.INVENTORY
