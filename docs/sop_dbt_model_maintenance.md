
### SOP: dbt Model Maintenance

**1. Purpose:**
To establish clear guidelines and best practices for the development, modification, testing, and deployment of dbt (data build tool) models within the `fcbi-staff-data-analyst-portfolio` project, ensuring consistency, reliability, and maintainability of our data transformations.

**2. Scope:**
This SOP applies to all dbt models located in the `dbt/models/` directory (staging, intermediate, marts) and covers all stages of their lifecycle from initial creation to deployment in BigQuery.

**3. Procedure:**

**3.1. Development Workflow:**
*   **Branching:** All new feature development or bug fixes for dbt models must be done in a dedicated Git branch, typically branching off `main`.
*   **Code Reviews:** All dbt model changes (SQL, YAML, tests) must undergo a peer code review before being merged into the `main` branch. Reviewers should ensure adherence to coding standards, correctness, and performance.
*   **Local Development:** Developers should test their dbt changes locally using `dbt build --select <model_name>` or `dbt run --select <model_name>` to verify functionality before pushing.

**3.2. Model Structure and Naming Conventions:**
*   **Folder Structure:**
    *   `staging/`: Models that perform light transformations directly from raw sources (e.g., column renaming, basic type casting, deduplication). Follow `stg_<source_name>__<table_name>` naming (e.g., `stg_loan_origination_data`).
    *   `intermediate/`: Models that join staging tables or perform more complex business logic, creating reusable datasets. Follow `int_<descriptive_name>` naming (e.g., `int_loan_performance_metrics`).
    *   `marts/`: Final, aggregated, and highly curated models designed for specific business use cases and reporting. Follow `agg_<descriptive_name>` or `fact_<descriptive_name>` naming (e.g., `agg_tier_performance_summary`).
*   **SQL Style:** Adhere to a consistent SQL style (e.g., uppercase keywords, consistent indentation, aliases).
*   **Documentation:** All dbt models (SQL files) and their columns must be documented in corresponding YAML files within the `dbt/models/` directory.

**3.3. Testing:**
*   **dbt Tests:** Implement dbt tests for all models to ensure data quality and integrity.
    *   **Generic Tests:** Use built-in tests like `unique`, `not_null`, `accepted_values`, `relationships` (for referential integrity).
    *   **Custom Tests:** Develop custom singular tests for complex business rules or cross-column validations.
*   **Running Tests:** Tests should be run as part of the CI/CD pipeline (`dbt test`) and locally during development.

**3.4. Version Control:**
*   **Git:** All dbt project files must be managed under Git in the `fcbi-staff-data-analyst-portfolio` repository.
*   **Commit Messages:** Follow a consistent commit message format (e.g., `feat(dbt): Add new model for XYZ`, `fix(dbt): Correct bug in ABC model`).

**3.5. Deployment:**
*   **CI/CD Pipeline:** dbt models are automatically built and tested via the `dbt_ci.yml` GitHub Actions workflow upon pull request merges to `main`.
*   **Environment Promotion:** Changes merged to `main` are typically deployed to production environments (BigQuery `prod` datasets, if configured) via automated processes.
*   **Materialization Strategy:** Choose appropriate materialization (view, table, incremental) based on data size, query performance needs, and refresh frequency.

**3.6. Performance Optimizations:**
*   **BigQuery Specifics:** Leverage BigQuery features like partitioning and clustering where appropriate for large tables, configured within the dbt model YAML files.
*   **SQL Optimization:** Write efficient SQL, avoid `SELECT *` in production models, and minimize full table scans.

**4. Roles & Responsibilities:**
*   **Data Engineer:** Primarily responsible for dbt project setup, CI/CD integration, model review, and deployment. Ensures overall dbt project health and performance.
*   **Data Analyst:** Responsible for developing, testing, and documenting dbt models; participating in code reviews; and ensuring models meet business requirements.

**5. Tools/Systems Used:**
*   dbt (data build tool)
*   Google BigQuery
*   Git/GitHub (for version control and CI/CD)

**6. Error Handling/Troubleshooting:**
*   **dbt Build/Run Failures:** Investigate error messages in the dbt logs (`dbt.log` or CI/CD logs). Check SQL syntax, table references, and data types.
*   **dbt Test Failures:** Review test output to identify which records or conditions violated the test. Debug by querying the underlying data.
*   **Deployment Rollback:** In case of critical issues post-deployment, revert to a previous working version in Git and trigger a re-deployment.
