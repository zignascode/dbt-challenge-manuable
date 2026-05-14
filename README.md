# dbt-challenge-manuable
Challenge/Prueba técnica Manuable
Contexto. Pipeline de transformación con dbt sobre BigQuery, garantizando calidad de datos y orquestación con Airflow.
Las capturas de pantalla y evidencias del proyecto se muestran en el archivo RESULTADOS.pdf

# Requisitos previos
Python 3.11.x
dbt-core 1.11.9 con plugin BigQuery 1.11.1
Cuenta de servicio en GCP con permisos:
Organization Policy Viewer (para la generación del la credencial json)
BigQuery Data Editor
BigQuery Job User
BigQuery User
Archivo de credenciales JSON (dbt-challenge-manuable-XXXX.json) configurado en profiles.yml.
1. Ir a Google Cloud Console → IAM & Admin → Service Accounts.
2. Crear una cuenta de servicio con permisos BigQuery.
3. Generar y descargar el archivo JSON.
4. Guardarlo en la carpeta Credentials/ con el nombre dbt-challenge.json.
5. Actualizar profiles.yml para apuntar a esa ruta.

Airflow 3.2.1 instalado en entorno Linux/WSL.

# Estructura del proyecto
models/
  staging → limpieza 1:1 de tablas raw
  intermediate → lógica de negocio
  marts → tablas finales para consumo
macros/ → macro customer_segment.sql
tests/ → genéricos + singular (test_orders_revenue_positive.sql)
dags/ → DAG dbt_pipeline.py (en la carpeta airflow instalada en el entorno de Linux)

# Instrucciones de uso
1. Instalar dependencias (pip install dbt-bigquery)
2. Configurar archivo profiles.yml con el nombre id del proyecto (dbt-challenge-manuable) y credenciales JSON:
3. Probar conexión (dbt debug)
4. Ejecución del pipeline dbt (dbt run --select staging|intermediate|marts)
5. Ver tablas generadas en BigQuery dentro del dataset dbt-challenge-manuable
6. Iniciar Airflow en modo standalone (airflow standalone)
7. Acceder a la interfaz en http://localhost:8080
8. Iniciar sesión con usuario y contraseña generados por la consola
9. DAG dbt_pipeline.py corre automáticamente a las 2:00 AM o puede ejecutarse manualmente desde la interfaz.
  Flujo: staging → test staging → marts → test marts.
  Si un test falla, el pipeline se detiene.
10. Generar documentación (dbt docs generate, dbt docs serve)
11. Ejecutar la consulta de Query_BQ.sql directamente en BigQuery