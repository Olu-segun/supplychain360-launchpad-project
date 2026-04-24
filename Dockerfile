FROM apache/airflow:3.1.8

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create dbt target dir with correct ownership before switching user
RUN mkdir -p /opt/airflow/dbt/target && \
    chown -R airflow: /opt/airflow/dbt

USER airflow

WORKDIR /opt/airflow

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY ingestion_layer/ /opt/airflow/ingestion_layer/
COPY dbt/ /opt/airflow/dbt/
COPY airflow/dags/ /opt/airflow/dags/
COPY utils/ /opt/airflow/utils/

# Ensure airflow owns everything including dbt/target
RUN chown -R airflow: /opt/airflow/dbt || true

ENV PYTHONPATH=/opt/airflow

CMD ["airflow", "standalone"]