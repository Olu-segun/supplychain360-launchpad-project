
SELECT
    DATA:"shipment_id"::STRING             AS SHIPMENT_ID,
    DATA:"shipment_date"::DATE             AS SHIPMENT_DATE,
    DATA:"expected_delivery_date"::DATE    AS EXPECTED_DELIVERY_DATE,
    DATA:"actual_delivery_date"::DATE      AS ACTUAL_DELIVERY_DATE,
    DATA:"carrier"::STRING                 AS CARRIER,
    DATA:"product_id"::STRING              AS PRODUCT_ID,
    DATA:"store_id"::STRING                AS STORE_ID,
    DATA:"warehouse_id"::STRING            AS WAREHOUSE_ID,
    DATA:"quantity_shipped"::NUMBER        AS QUANTITY_SHIPPED
FROM SUPPLYCHAIN360_DB.RAW.SHIPMENTS


