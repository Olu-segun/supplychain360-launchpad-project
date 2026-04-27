{{
  config(
    materialized = 'table',
    )
}}
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    p.brand_name,
    p.unit_price
FROM {{ ref('stg_products') }} p