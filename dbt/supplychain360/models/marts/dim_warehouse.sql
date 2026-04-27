{{
      config(
        materialized = 'table',
        )
    }}

SELECT 
    warehouse_id,
    city,
    state,
    ingestion_timestamp
FROM {{ ref("stg_warehouse") }}