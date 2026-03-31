
SELECT
    DATA:"transaction_id"::STRING                  AS TRANSACTION_ID,
    TO_TIMESTAMP(DATA:"transaction_timestamp"::NUMBER / 1e9) AS TRANSACTION_TIMESTAMP,
    DATA:"store_id"::STRING                        AS STORE_ID,
    DATA:"product_id"::STRING                      AS PRODUCT_ID,
    DATA:"quantity_sold"::NUMBER                   AS QUANTITY_SOLD,
    DATA:"unit_price"::FLOAT                       AS UNIT_PRICE,
    DATA:"sale_amount"::FLOAT                      AS SALE_AMOUNT,
    DATA:"discount_pct"::FLOAT                     AS DISCOUNT_PCT,
    TO_TIMESTAMP(DATA:"ingestion_timestamp"::NUMBER / 1e6) AS INGESTION_TIMESTAMP
FROM SUPPLYCHAIN360_DB.RAW.SALES
