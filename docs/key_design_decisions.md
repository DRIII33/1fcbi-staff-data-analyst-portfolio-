
#### 3. Key Design Decisions and Rationale

This section captures the reasoning behind significant choices made during the project, facilitating future understanding, maintenance, and strategic iteration.

**3.1. Technology Stack Selection**
*   **Decision:** Google BigQuery for Data Warehouse, dbt for Transformations, Python for Data Generation/Advanced Analytics, Great Expectations for Data Quality, GitHub Actions for CI/CD.
*   **Rationale:**
    *   **BigQuery:** Chosen for its serverless architecture, columnar storage, auto-scaling capabilities, and SQL-first approach, which aligns with modern data warehousing practices and reduces operational overhead. Its seamless integration within the Google Cloud ecosystem is a significant advantage.
    *   **dbt (data build tool):** Selected to manage data transformations due to its SQL-centric approach, enabling data analysts to build, test, and document data models collaboratively. It enforces best practices like version control, modularity, and testing, crucial for maintainability and data governance. Its ability to create DAGs (Directed Acyclic Graphs) directly from SQL `ref()` statements simplifies complex dependencies.
    *   **Python:** Utilized for data generation (to simulate real-world data), data ingestion (`pandas_gbq`), and advanced analytical modeling (e.g., `RandomForestClassifier`, `Prophet`). Python's extensive libraries for data manipulation (`pandas`), machine learning (`scikit-learn`), and time-series analysis make it versatile for data science tasks.
    *   **Great Expectations:** Chosen as the data quality framework for its explicit validation of data expectations, generation of human-readable `Data Docs`, and seamless integration into CI/CD pipelines. This proactive approach ensures data quality at the source, preventing bad data from polluting downstream systems.
    *   **GitHub Actions:** Employed for continuous integration and continuous delivery (CI/CD) due to its native integration with GitHub repositories. It automates testing, deployment, and data quality checks, ensuring that changes are thoroughly validated and deployed efficiently.

**3.2. Data Modeling Approach (Layers)**
*   **Decision:** Implementation of a multi-layered data architecture within BigQuery: Raw, Staging, Intermediate, and Marts.
*   **Rationale:**
    *   **Raw Layer (`driiiportfolio.raw`):** Stores data exactly as it was ingested, providing an immutable historical record. This allows for reproducibility and auditing, serving as the single source of truth for raw data.
    *   **Staging Layer:** Performs minimal transformations like column renaming, basic type casting, and deduplication (e.g., `stg_loan_performance_history` for duplicate snapshots). This isolates initial cleanup from complex business logic and provides a clean, standardized base for further processing.
    *   **Intermediate Layer:** Combines data from staging tables and applies more complex business logic, creating reusable, enriched datasets (e.g., `int_loan_performance_metrics`). This prevents redundant logic across multiple mart models and centralizes complex calculations.
    *   **Mart Layer (`driiiportfolio.marts`):** Designed for specific business use cases (e.g., `agg_tier_performance_summary`). These models are highly curated, aggregated, and optimized for consumption by BI tools and analytical applications. This ensures high performance for reporting and provides a business-friendly view of the data.
    *   This layered approach promotes modularity, testability, reusability, and makes it easier to troubleshoot and maintain the data pipeline.

**3.3. Validation Rules and Data Quality Strategy**
*   **Decision:** Comprehensive Great Expectations suites for both `loan_origination_data` and `loan_performance_history`, with specific rules for uniqueness, nullness, data types, ranges, set membership, and referential/temporal integrity.
*   **Rationale:** Proactive data quality checks at the ingestion layer are critical to prevent
