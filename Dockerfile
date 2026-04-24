FROM apache/airflow:3.1.8

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/airflow


COPY requirements.txt .
COPY ingestion_layer/ /opt/airflow/ingestion_layer/
COPY dbt/ /opt/airflow/dbt/
COPY airflow/dags/ /opt/airflow/dags/
COPY utils/ /opt/airflow/utils/


RUN chown -R airflow:0 /opt/airflow

USER airflow


RUN pip install --no-cache-dir -r requirements.txt


ENV DBT_TARGET_PATH=/tmp/dbt_target

ENV PYTHONPATH=/opt/airflow

CMD ["airflow", "standalone"]