
### SOP: Ad-Hoc Data Requests

**1. Purpose:**
To provide a structured and efficient process for handling ad-hoc data requests from stakeholders, ensuring timely delivery of accurate information while maintaining data governance and security standards.

**2. Scope:**
This SOP applies to all requests for data not directly available through existing reports, dashboards, or self-service tools. It covers requests for raw data extracts, custom analyses, or specific data manipulations from the BigQuery datasets (raw, staging, intermediate, marts).

**3. Procedure:**

**3.1. Request Submission:**
*   **Method:** All ad-hoc data requests must be submitted via a designated channel (e.g., JIRA ticket, specific email alias, or a formal request form).
*   **Required Information:** The requester must provide the following details:
    *   **Business Question/Goal:** Clearly articulate the problem to be solved or the insight needed.
    *   **Desired Data Fields:** List specific columns or data points required.
    *   **Source Table(s) (if known):** Indicate preferred data sources.
    *   **Filters/Conditions:** Any specific criteria to apply (e.g., date ranges, customer segments).
    *   **Output Format:** Preferred format for data delivery (e.g., CSV, Excel, Google Sheet, direct BigQuery access).
    *   **Urgency/Deadline:** Required timeframe for completion.
    *   **Justification for Ad-Hoc:** Explain why existing resources cannot fulfill the request.

**3.2. Request Review and Prioritization:**
*   **Initial Review:** The data team lead or assigned data analyst will review the request within [e.g., 24 business hours] to ensure all necessary information is provided.
*   **Clarification:** If information is missing or unclear, the data analyst will contact the requester for clarification.
*   **Feasibility Assessment:** Evaluate the feasibility of fulfilling the request, considering data availability, technical complexity, and estimated effort.
*   **Prioritization:** Prioritize requests based on business impact, urgency, and resource availability. Communicate estimated completion time or any potential delays to the requester.

**3.3. Data Extraction and Analysis:**
*   **Tooling:** Use SQL (BigQuery console or `pandas_gbq` for Python scripts) to extract and manipulate data.
*   **Query Development:** Write optimized SQL queries, leveraging dbt mart models where possible, to extract the requested data.
*   **Security:** Ensure that only necessary data is extracted and shared, adhering to data access policies and privacy regulations (e.g., PII masking if required).
*   **Validation:** Perform sanity checks on the extracted data to ensure accuracy and consistency with the request.
*   **Documentation (Ad-Hoc Queries):** Store complex or frequently requested ad-hoc queries in a version-controlled repository (e.g., `dbt/analyses` or a dedicated `ad_hoc_queries` folder within `src/`). Document the purpose of the query, requester, date, and any specific parameters.

**3.4. Data Delivery:**
*   Deliver the data in the requested format to the agreed-upon location (e.g., Google Drive, shared Google Sheet, email attachment, or grant BigQuery view access).
*   Provide any necessary context, caveats, or interpretations of the data.

**3.5. Post-Delivery Feedback:**
*   Seek feedback from the requester to ensure the delivered data met their needs and expectations.

**4. Roles & Responsibilities:**
*   **Requester:** Responsible for submitting clear, complete data requests.
*   **Data Analyst:** Responsible for reviewing, clarifying, prioritizing, extracting, analyzing, and delivering data for ad-hoc requests. Documents ad-hoc queries.
*   **Data Team Lead:** Provides oversight, assists with prioritization, and resolves escalations.

**5. Tools/Systems Used:**
*   JIRA/Request Management System (e.g., Slack channel, email)
*   Google BigQuery (SQL Console, `pandas_gbq`)
*   Python/Pandas (for complex transformations or large extracts)
*   Google Drive/Sheets (for delivery)
*   Git/GitHub (for version control of ad-hoc queries)

**6. Error Handling/Troubleshooting:**
*   **Unclear Request:** Return to requester for clarification.
*   **Data Not Found:** Communicate unavailability and explore alternative data sources if feasible.
*   **Performance Issues:** Optimize SQL queries, use appropriate BigQuery features (partitioning, clustering), or escalate to Data Engineer.
*   **Delivery Issues:** Verify access permissions to shared drives/sheets or confirm email addresses.
