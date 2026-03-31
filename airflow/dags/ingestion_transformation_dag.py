import sys
import os
from airflow import DAG
from datetime import datetime, timedelta
from airflow.providers.standard.operators.bash import BashOperator
from airflow.providers.standard.operators.python import PythonOperator
from airflow.providers.snowflake.operators.snowflake import SnowflakeOperator
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "../../")))

default_args = {
    "owner": "olukayode_olusegun",
    "email": ["olukayodeoluseguno@gmail.com"],
    "email_on_failure": True,
    "email_on_success": True,
    "email_on_retry": True,
    "retries": 3,
    "retry_delay": timedelta(minutes=1),
}
with DAG(
    dag_id="supplychain360_dag",
    default_args=default_args,
    schedule="@daily",
    start_date=datetime(2026, 3, 24),
    catchup=False,
    tags=["s3", "postgres", "google_sheet"],
) as dag:
    
# -----------------------------
# Lazy wrapper functions
# -----------------------------
    def run_s3_pipeline():
        from ingestion_layer.s3_ingestion import s3_ingestion_pipeline
        s3_ingestion_pipeline()


    def run_postgres_pipeline():
        from ingestion_layer.postgres_ingestion import postgres_ingestion_pipeline
        postgres_ingestion_pipeline()
        
    def run_sheet_pipeline():
        from ingestion_layer.google_sheet_ingestion import google_sheet_ingestion_pipeline
        google_sheet_ingestion_pipeline()



    s3_pipeline_task = PythonOperator(
        task_id="run_s3_ingestion_pipeline",
        python_callable=run_s3_pipeline,
    )

    postgres_pipeline_task = PythonOperator(
        task_id="run_postgres_ingestion_pipeline",
        python_callable=run_postgres_pipeline,
    )

    sheet_pipeline_task = PythonOperator(
        task_id="run_sheet_ingestion_pipeline",
        python_callable=run_sheet_pipeline,
    )
    
    
    # Data Ingestion from s3 Bucket to raw schema in snowflake
    
    copy_store_locations = SnowflakeOperator(
        task_id="copy_store_locations",
        sql="""COPY INTO supplychain360_db.raw.store_locations
               FROM @supplychain360_db.raw.supplychain360_s3_stage/retail_store_locations/
               FILE_FORMAT = (TYPE = PARQUET);""",
        snowflake_conn_id="snowflake_conn"
    )
    
    
    copy_products = SnowflakeOperator(
        task_id="copy_products",
        sql="""COPY INTO supplychain360_db.raw.products
               FROM @supplychain360_db.raw.supplychain360_s3_stage/product_catalog_master/
               FILE_FORMAT = (TYPE = PARQUET);""",
        snowflake_conn_id="snowflake_conn"
    )
    
    
    copy_shipments = SnowflakeOperator(
        task_id="copy_shipments",
        sql="""COPY INTO supplychain360_db.raw.shipments
               FROM @supplychain360_db.raw.supplychain360_s3_stage/shipment_delivery_logs/
               FILE_FORMAT = (TYPE = PARQUET);""",
        snowflake_conn_id="snowflake_conn"
    )
    

    copy_sales = SnowflakeOperator(
        task_id="copy_sales",
        sql="""COPY INTO supplychain360_db.raw.sales
               FROM @supplychain360_db.raw.supplychain360_s3_stage/store_sales_transactions/
               FILE_FORMAT = (TYPE = PARQUET);""",
        snowflake_conn_id="snowflake_conn"
    )
    
    copy_suppliers = SnowflakeOperator(
        task_id="copy_suppliers",
        sql="""COPY INTO supplychain360_db.raw.suppliers
               FROM @supplychain360_db.raw.supplychain360_s3_stage/supplier_registry_data/
               FILE_FORMAT = (TYPE = PARQUET);""",
        snowflake_conn_id="snowflake_conn"
    )
    
    copy_inventory = SnowflakeOperator(
        task_id="copy_inventory",
        sql="""COPY INTO supplychain360_db.raw.inventory
               FROM @supplychain360_db.raw.supplychain360_s3_stage/warehouse_inventory/
               FILE_FORMAT = (TYPE = PARQUET);""",
        snowflake_conn_id="snowflake_conn"
    )
    
    copy_warehouses = SnowflakeOperator(
        task_id="copy_warehouses",
        sql="""COPY INTO supplychain360_db.raw.warehouses
               FROM @supplychain360_db.raw.supplychain360_s3_stage/warehouse_master_data/
               FILE_FORMAT = (TYPE = PARQUET);""",
        snowflake_conn_id="snowflake_conn"
    )
    
# dbt transformation step
    run_dbt = BashOperator(
    task_id="run_dbt",
    bash_command="cd /path/to/dbt/project && dbt build"
)
    
    
    s3_pipeline_task >> postgres_pipeline_task >> sheet_pipeline_task >> [copy_store_locations, copy_products, copy_shipments, copy_sales, copy_suppliers, copy_inventory,copy_warehouses  ] >> run_dbt