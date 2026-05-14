# dbt-challenge-manuable  
Prueba técnica Manuable  

## 📌 Contexto  
Pipeline de transformación con **dbt** sobre **BigQuery**, garantizando calidad de datos y orquestación con **Airflow**.  
Las capturas de pantalla y evidencias del proyecto se encuentran en `RESULTADOS.pdf`.  

---

## ⚙️ Requisitos previos  
- Python 3.11.x  
- dbt-core 1.11.9 con plugin BigQuery 1.11.1  
- Airflow 3.2.1 en entorno Linux/WSL  
- Cuenta de servicio en GCP con permisos:  
  - Organization Policy Viewer (para generar credencial JSON)  
  - BigQuery Data Editor  
  - BigQuery Job User  
  - BigQuery User  
- Archivo de credenciales JSON (`dbt-challenge.json`) configurado en `profiles.yml`  

---

## 🚀 Configuración inicial  

### 1. Crear cuenta de servicio en GCP  
1. Ir a **Google Cloud Console → IAM & Admin → Service Accounts**  
2. Crear cuenta con permisos BigQuery  
3. Descargar archivo JSON y guardarlo en `Credentials/dbt-challenge.json`  

### 2. Configurar perfiles de dbt  
1. Copiar `profiles.yml.example` a la carpeta `.dbt` de su usuario:  
   - Windows: `C:\Users\<usuario>\.dbt\`  
   - Linux/Mac: `~/.dbt/`  
2. Renombrar a `profiles.yml`  
3. Editar el archivo reemplazando:  
   - `<TU_PROYECTO_GCP>` → ID de su proyecto en GCP  
   - `dataset` → nombre del dataset  
   - `location` → región del dataset  
   - `keyfile` → ruta local del JSON de credenciales  

### 3. Poblar dataset RAW  
Ejecutar el script `dataset_raw.sql` en BigQuery para crear y llenar las tablas iniciales en el esquema `raw`.  

---

## 📂 Estructura del proyecto  
- **models/**  
  - staging → limpieza 1:1 de tablas raw  
  - intermediate → lógica de negocio  
  - marts → tablas finales para consumo  
- **macros/** → macro `customer_segment.sql`  
- **tests/** → genéricos + singular (`test_orders_revenue_positive.sql`)  
- **dags/** → DAG `dbt_pipeline.py` (ubicado en carpeta de Airflow)  

---

## ▶️ Instrucciones de uso 

```bash
# 1. Instalar dependencias
pip install dbt-bigquery==1.11.1

# 2. Probar conexión
dbt debug

# 3. Ejecutar pipeline dbt
dbt run --select staging
dbt run --select intermediate
dbt run --select marts
dbt test

# 4. Ver tablas generadas en BigQuery dentro del dataset configurado

# 5. Iniciar Airflow en modo standalone
airflow standalone

# 6. Acceder a la interfaz en http://localhost:8080
#    Iniciar sesión con credenciales generadas en consola

# 7. Ejecutar DAG dbt_pipeline.py
#    Corre automáticamente a las 2:00 AM o puede ejecutarse manualmente
#    Flujo: staging → test staging → marts → test marts
#    Si un test falla, el pipeline se detiene

# 8. Generar documentación
dbt docs generate
dbt docs serve

# 9. Ejecutar consulta analítica en BigQuery
#    Usar el archivo Query_BQ.sql
