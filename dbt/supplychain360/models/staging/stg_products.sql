
SELECT
    DATA:"product_id"::STRING      AS PRODUCT_ID,
    DATA:"product_name"::STRING    AS PRODUCT_NAME,
    DATA:"brand"::STRING           AS BRAND,
    DATA:"category"::STRING        AS CATEGORY,
    DATA:"supplier_id"::STRING     AS SUPPLIER_ID,
    DATA:"unit_price"::FLOAT       AS UNIT_PRICE
FROM SUPPLYCHAIN360_DB.RAW.PRODUCTS
