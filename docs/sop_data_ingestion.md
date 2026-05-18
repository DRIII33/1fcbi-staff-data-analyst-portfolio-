
### SOP: Data Ingestion

**1. Purpose:**
To establish a standardized process for ingesting raw data into the `driiiportfolio.raw` BigQuery dataset, ensuring consistency, reliability, and preparedness for subsequent data quality checks and transformations.

**2. Scope:**
This SOP covers the ingestion of all raw data files (e.g., CSV, JSON) into the `driiiportfolio.raw` dataset, specifically for `loan_origination_data` and `loan_performance_history`, and any new data sources identified for the raw layer.

**3. Procedure:**

**3.1. Data Source Identification and Access:**
*   Identify the source of the raw data (e.g., local files, cloud storage, API endpoint).
*   Ensure appropriate access permissions are granted for the ingestion mechanism (e.g., Google Cloud Storage, service account credentials).

**3.2. Data Preparation (Pre-Ingestion):**
*   **Review Source Schema:** Understand the structure, data types, and potential issues (e.g., encoding, delimiters) of the source data.
*   **File Format:** Ensure the data is in a supported format (CSV, JSON, Parquet). If necessary, convert data to a preferred format.
*   **Column Naming:** If possible, align column names with BigQuery's best practices (lowercase, snake_case) and project conventions before ingestion.

**3.3. Ingestion into BigQuery Raw Layer:**
*   **Tooling:** Use `pandas_gbq` for programmatic ingestion of DataFrames into BigQuery tables.
*   **Destination:** All raw data must be ingested into the `driiiportfolio.raw` dataset.
*   **Table Naming Convention:** Raw tables should follow the naming convention: `<source_system_name>_<data_entity_name>` (e.g., `loan_origination_data`, `loan_performance_history`).
*   **`if_exists` Parameter:** For initial loads or full refreshes, use `if_exists='replace'`. For incremental updates, use `if_exists='append'` and ensure proper deduplication/upsert logic in downstream dbt models.
*   **Date/Timestamp Columns:** Ensure date and timestamp columns are parsed correctly as `datetime` objects in Pandas before uploading to BigQuery to allow BigQuery to infer appropriate `DATE` or `TIMESTAMP` types.

    ```python
    import pandas as pd
    import pandas_gbq

    project_id = 'driiiportfolio'

    # Example for loan_origination_data
    loan_origination_df = pd.read_csv('/path/to/your/loan_origination_data.csv', parse_dates=['origination_date'])
    loan_origination_df.to_gbq(
        destination_table='raw.loan_origination_data',
        project_id=project_id,
        if_exists='replace'
    )

    # Example for loan_performance_history
    loan_performance_df = pd.read_csv('/path/to/your/loan_performance_history.csv', parse_dates=['report_date'])
    loan_performance_df.to_gbq(
        destination_table='raw.loan_performance_history',
        project_id=project_id,
        if_exists='replace'
    )
    print("Data ingested to BigQuery raw layer.")
    ```

**3.4. Post-Ingestion Validation Trigger:**
*   Immediately after successful data ingestion, trigger the automated data quality checks (as defined in the SOP for Data Quality Checks) to validate the newly ingested data.

**4. Roles & Responsibilities:**
*   **Data Engineer:** Responsible for developing, testing, and executing data ingestion scripts; ensuring proper BigQuery table creation and data loading; and integrating ingestion with data quality check pipelines.
*   **Data Owner:** Provides source data, schema information, and confirms successful ingestion.

**5. Tools/Systems Used:**
*   Python with `pandas` and `pandas_gbq` libraries.
*   Google BigQuery.
*   Google Cloud Storage (if data is staged there).
*   GitHub Actions (for CI/CD automation of ingestion).

**6. Error Handling/Troubleshooting:**
*   **Ingestion Failure:** If `pandas_gbq` reports an error, review the error message for details (e.g., schema mismatch, authentication issues, network problems).
*   **Schema Mismatch:** If BigQuery encounters schema inference issues, explicitly define the schema using `table_schema` parameter in `to_gbq` or pre-create the table with a defined schema.
*   **Data Corruption:** If data appears corrupted post-ingestion, verify the source file integrity and the parsing logic in Pandas.
*   **Authentication Errors:** Ensure the Colab environment or CI/CD runner has the necessary BigQuery Data Editor permissions for the `driiiportfolio` project.
