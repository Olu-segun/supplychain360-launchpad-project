# dags/test_dag.py

from airflow import DAG
from airflow.decorators import task
from airflow.providers.google.suite.hooks.sheets import GspreadHook
from airflow.providers.amazon.aws.hooks.s3 import S3Hook
import pandas as pd
import io
from datetime import datetime


with DAG(
    dag_id="supplychain360_dag",
    start_date=datetime(2026, 3, 21),
    schedule=None,
    catchup=False
) as dag:
    
    # Idempotent S3 path: bucket/data/2026-03-21/sheet_data.parquet
    S3_KEY = "store_data/{{ ds }}/sheet_data.parquet"
    BUCKET = "your-s3-bucket"
    
    def gsheet_to_s3_parquet():

        @task
        def extract_and_load():
            # 1. Extract from Google Sheets
            gspread_hook = GspreadHook(gcp_conn_id="google_conn_id")
            sheet = gspread_hook.spreadsheet(spreadsheet_id="your_sheet_id")
            worksheet = sheet.worksheet("Sheet1")
            data = worksheet.get_all_records()
            
            # 2. Convert to Pandas
            df = pd.DataFrame(data)
            
            # 3. Convert to Parquet
            parquet_buffer = io.BytesIO()
            df.to_parquet(parquet_buffer, index=False)
            
            # 4. Upload to S3 (Idempotent: overwrites same day, creates new file for new day)
            s3_hook = S3Hook(aws_conn_id="aws_conn_id")
            s3_hook.load_bytes(
                parquet_buffer.getvalue(),
                key=S3_KEY,
                bucket_name=BUCKET,
                replace=True # Ensures idempotency
            )

        extract_and_load()

    gsheet_to_s3_parquet()