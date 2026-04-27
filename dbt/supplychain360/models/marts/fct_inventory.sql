{{ config(materialized='table') }}

SELECT
    i.product_id,
    i.warehouse_id,
    p.supplier_id,
    p.product_name,
    p.category,
    p.brand_name,
    w.city as warehouse_city,
    w.state as warehouse_state,
    i.quantity_available,
    i.reorder_threshold,
   CASE
        WHEN i.quantity_available = 0 then 'Out of stock'
        WHEN i.quantity_available <= i.reorder_threshold then 'Low stock'
        ELSE 'In stock'
    END AS stock_status,
    i.snapshot_date
FROM {{ ref('stg_inventory') }} i
LEFT JOIN {{ ref('stg_products') }} p on i.product_id = p.product_id
LEFT JOIN {{ ref('stg_warehouse') }} w on i.warehouse_id = w.warehouse_id