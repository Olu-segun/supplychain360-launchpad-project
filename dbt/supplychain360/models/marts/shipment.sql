{{ config(materialized='table') }}

SELECT
    sh.shipment_id,
    sh.product_id,
    sh.warehouse_id,
    sh.store_id,
    p.supplier_id,
    sh.carrier,
    w.city as warehouse_city,
    w.state as warehouse_state,
    st.state as store_city,
    st.region as store_region,
    sh.quantity_shipped,
    sh.shipment_date,
    sh.actual_delivery_date,
    case when sh.actual_delivery_date > sh.expected_delivery_date
        then 'Late'
        else 'On time'
    end as delivery_status,
    datediff(day, sh.shipment_date, sh.actual_delivery_date) as delivery_duration_days
from {{ ref('stg_shipments') }} sh
join {{ ref('stg_products') }} p on sh.product_id = p.product_id
join {{ ref('stg_store_locations') }} st on sh.store_id = st.store_id
join {{ ref('stg_warehouse') }} w on sh.warehouse_id = w.warehouse_id