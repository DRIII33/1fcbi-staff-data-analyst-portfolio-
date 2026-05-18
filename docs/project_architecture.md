
### Project Architecture and Data Flow Documentation

**1. Overall Project Architecture**

This project implements a modern data stack architecture on Google Cloud Platform, leveraging several key technologies to ensure data reliability, scalability, and accessibility. The core components are:

*   **Google BigQuery (Data Warehouse):** Serves as the central data warehouse, hosting all raw, staged, intermediate, and mart data layers. Its serverless nature, scalability, and analytical capabilities are fundamental to the project.
    *   **Roles:**
        *   **`driiiportfolio.raw` dataset:** Stores the immutable, raw data directly ingested from source systems (e.g., `loan_origination_data`, `loan_performance_history`).
        *   **`driiiportfolio.staging` dataset:** (Implicitly created by dbt as views/tables) Holds cleaned and type-casted data from the raw layer, preparing it for further transformation.
        *   **`driiiportfolio.intermediate` dataset:** (Implicitly created by dbt as views/tables) Contains aggregated and joined data, forming reusable building blocks for analytics (e.g., `int_loan_performance_metrics`).
        *   **`driiiportfolio.marts` dataset:** (Implicitly created by dbt as views/tables) Provides highly curated, business-friendly data models optimized for reporting and analytics (e.g., `agg_tier_performance_summary`).

*   **dbt (data build tool - Transformation Layer):** Orchestrates and manages all data transformations within BigQuery. It defines data models, relationships, and tests using SQL, promoting modularity, reusability, and version control.
    *   **Roles:**
        *   **Staging Models:** Initial cleaning, type casting, and deduplication of raw data.
        *   **Intermediate Models:** Complex business logic, joining of staged data, and creation of derived metrics.
        *   **Mart Models:** Final aggregation and structuring of data for specific business use cases and reporting.

*   **Python Scripts (Data Generation, Ingestion, Advanced Analytics):**
    *   **Data Generation (`src/data_generation.py`):** Creates synthetic `loan_origination_data` and `loan_performance_history` datasets for simulation and testing.
    *   **Data Ingestion (`pandas_gbq`):** Utilized to load generated CSV data into the BigQuery `raw` layer.
    *   **Risk Analysis Model (`src/modeling/risk_predictor.py`):** Implements a `RandomForestClassifier` for predicting loan default and identifying key risk factors.
    *   **Time-Series Forecasting (Conceptual `Prophet`):** Used for forecasting branch performance metrics.
    *   **Marketing ROI Analysis:** Performs calculations and provides insights into campaign effectiveness.

*   **Great Expectations (Data Quality Framework):** Ensures the integrity, consistency, and validity of data at critical points in the pipeline.
    *   **Roles:**
        *   Defines data quality expectations (e.g., uniqueness, non-null, range checks, referential integrity).
        *   Executes validation against BigQuery tables.
        *   Generates `Data Docs` for human-readable validation reports.

*   **GitHub Actions (CI/CD and Workflow Automation):** Automates the execution of data pipelines, including data ingestion, quality checks, and dbt transformations.
    *   **Roles:**
        *   Automated data ingestion.
        *   Automated Great Expectations validation post-ingestion.
        *   Automated dbt build and test runs.

*   **Looker Studio / BI Tools (Reporting & Visualization Layer - Planned):** The final destination for curated data, providing interactive dashboards and reports for business stakeholders.
    *   **Roles:**
        *   Visualize key performance indicators from dbt mart models.
        *   Enable drill-down analysis for executive insights.

**Interactions:**

1.  **Data Generation:** Python scripts create synthetic datasets.
2.  **Data Ingestion:** Python (`pandas_gbq`) loads raw data into BigQuery's `raw` dataset.
3.  **Data Quality (Great Expectations):** Automatically runs validations on the `raw` data after ingestion. Failures can halt the pipeline.
4.  **dbt Transformations:** Transforms data from `raw` -> `staging` -> `intermediate` -> `marts` within BigQuery.
5.  **Advanced Analytics (Python):** Consumes data from `intermediate` or `marts` to build predictive models and conduct in-depth analysis.
6.  **Reporting & Visualization:** BI tools connect directly to the `marts` dataset for dashboard creation and reporting.

#### 2. End-to-End Data Flow

This section describes the journey of data through the FCBI data platform, from its origin as raw synthetic data to its consumption in reporting and analytical models.

**Conceptual Diagram:**

```mermaid
graph TD
    A[Data Generation (Python)] --> B(Data Ingestion (pandas_gbq))
    B --> C{BigQuery Raw Layer}
    C --> D[Data Quality Checks (Great Expectations)]
    D -- Pass --> E[dbt Staging Models]
    D -- Fail --> F[Quarantine / Alert]
    E --> G[dbt Intermediate Models]
    G --> H[dbt Mart Models]
    H --> I[Advanced Analytics (Python Models)]
    H --> J[Reporting & Visualization (Looker Studio / BI Tools)]

    subgraph Raw Layer
        C
    end

    subgraph Transformation Layer (dbt)
        E
        G
        H
    end

    subgraph Data Consumption
        I
        J
    end

    subgraph Data Governance & Monitoring
        D
        F
    end
```

**Step-by-Step Narrative:**

1.  **Data Generation:**
    *   **Process:** Synthetic data for `loan_origination_data` and `loan_performance_history` is generated using Python scripts (`src/data_generation.py`). This simulates real-world loan data for development and testing purposes.
    *   **Outcome:** Two CSV files (`loan_origination_data.csv`, `loan_performance_history.csv`) are created, representing the initial raw data.

2.  **Data Ingestion:**
    *   **Process:** The generated CSV files are ingested into the BigQuery `raw` layer using Python scripts that leverage `pandas_gbq`. This process loads the data as-is, preserving its original structure and values.
    *   **Destination:** `driiiportfolio.raw.loan_origination_data` and `driiiportfolio.raw.loan_performance_history` tables in BigQuery.

3.  **Data Quality Checks:**
    *   **Process:** Immediately after ingestion, Great Expectations runs a suite of predefined data quality checks against the newly loaded raw tables. These checks validate schema, data types, uniqueness, completeness (non-nulls), value ranges, and referential integrity.
    *   **Outcome:**
        *   **Pass:** If all critical expectations pass, the data is deemed ready for transformation, and the pipeline proceeds to dbt staging.
        *   **Fail:** If any critical expectations fail, the pipeline halts. Alerts are sent to relevant stakeholders, and the problematic data batch is quarantined in a dedicated BigQuery dataset (`driiiportfolio.quarantine`). Detailed `Data Docs` are generated to facilitate debugging.

4.  **dbt Staging Models:**
    *   **Process:** The first layer of dbt transformations occurs in the `staging` models (`stg_loan_origination_data`, `stg_loan_performance_history`). These models perform initial cleaning steps like column renaming, basic type casting, and deduplication (e.g., handling duplicate `application_id`/`report_date` snapshots in `loan_performance_history`).
    *   **Outcome:** Cleaned, standardized tables (as BigQuery views or tables) in the `driiiportfolio.staging` dataset, ready for more complex business logic.

5.  **dbt Intermediate Models:**
    *   **Process:** The `intermediate` models (e.g., `int_loan_performance_metrics`) join data from the `staging` layer and calculate derived metrics (e.g., `loan_age_days`, `is_delinquent`, `loan_status_category`). This layer focuses on creating reusable, aggregated datasets that simplify subsequent analysis.
    *   **Outcome:** Consolidated and enriched tables (views or tables) in the `driiiportfolio.intermediate` dataset.

6.  **dbt Mart Models:**
    *   **Process:** The `marts` models (e.g., `agg_tier_performance_summary`) are the final layer of dbt transformations. They aggregate data and structure it into business-friendly schemas optimized for specific use cases, such as reporting and executive insights. Strategic flags (e.g., `strategic_recommendation`) are often added here.
    *   **Outcome:** Highly curated, performant tables (views or tables) in the `driiiportfolio.marts` dataset, directly serving business intelligence and analytical needs.

7.  **Advanced Analytics and Modeling:**
    *   **Process:** Python-based analytical models consume data from the `intermediate` or `marts` layers to perform advanced analyses.
        *   **Risk Analysis Model (`RandomForestClassifier`):** Predicts loan default and identifies key feature importances (e.g., `ltv_ratio`, `credit_score`).
        *   **Time-Series Forecasting (`Prophet`):** Forecasts trends and seasonality for metrics like branch performance.
        *   **Marketing ROI Analysis:** Evaluates campaign effectiveness using data on costs, conversions, and value generated.
    *   **Outcome:** Predictive insights, forecasts, and actionable recommendations for business decision-makers.

8.  **Reporting and Visualization:**
    *   **Process:** Business Intelligence (BI) tools (e.g., Looker Studio, Tableau) connect directly to the `marts` dataset.
    *   **Outcome:** Interactive dashboards and reports providing key performance indicators (KPIs), trend analysis, and strategic insights for various stakeholders, enabling data-driven decision-making.
