from airflow import DAG
from airflow.providers.standard.operators.bash import BashOperator
from datetime import datetime

with DAG(
    dag_id="dbt_pipeline",
    start_date=datetime(2024, 1, 1),
    schedule="0 2 * * *",  # todos los días a las 2:00 AM
    catchup=False,
) as dag:

    run_staging = BashOperator(
        task_id="run_staging",
        bash_command="cd /mnt/c/Users/mar_z/Desktop/dbt-challenge-manuable && dbt run --select staging",
    )

    test_staging = BashOperator(
        task_id="test_staging",
        bash_command="cd /mnt/c/Users/mar_z/Desktop/dbt-challenge-manuable && dbt test --select staging",
    )

    run_marts = BashOperator(
        task_id="run_marts",
        bash_command="cd /mnt/c/Users/mar_z/Desktop/dbt-challenge-manuable && dbt run --select marts",
    )

    test_marts = BashOperator(
        task_id="test_marts",
        bash_command="cd /mnt/c/Users/mar_z/Desktop/dbt-challenge-manuable && dbt test --select marts",
    )

    run_staging >> test_staging >> run_marts >> test_marts