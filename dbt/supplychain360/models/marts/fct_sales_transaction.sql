{{
  config(
    materialized = 'table',
    )
}}
SELECT
      s.transaction_id,
      s.product_id,
      s.store_id,
      s.quantity_sold,
      s.unit_price,
      s.discount_pct AS discount_amount,
      s.quantity_sold * s.unit_price AS total_sales_amount,
      s.transaction_timestamp,
      CAST(s.transaction_timestamp AS DATE) AS transaction_date
FROM {{ ref('stg_sales_transaction') }} s