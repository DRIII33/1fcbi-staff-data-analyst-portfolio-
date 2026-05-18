# FCBI Staff Data Analyst Portfolio Project

This repository contains the solution for the FCBI Staff Data Analyst portfolio project, addressing the core business challenge of bridging fragmented legacy financial systems with executive-level strategic reporting. The solution implements a modernized data infrastructure leveraging Google Cloud Platform services, dbt for transformations, Python for advanced analytics, Great Expectations for data quality, and GitHub Actions for CI/CD.

## Project Overview

The project aims to provide near real-time operational visibility, significantly reduce data lag, save manual effort, increase loan decision accuracy, and enhance risk exposure metrics within FCBI's consumer lending division.

## Key Components

*   **Data Generation:** Synthetic loan origination and performance data are generated using Python scripts to simulate real-world scenarios.
*   **Data Ingestion:** Data is ingested into Google BigQuery, serving as the central data warehouse.
*   **Data Quality:** Great Expectations is used to define and enforce data quality rules, ensuring data integrity at every stage.
*   **Data Transformation:** dbt (data build tool) is employed to transform raw data into cleaned, standardized, and aggregated models (staging, intermediate, marts).
*   **Advanced Analytics & Modeling:** Python is used to develop risk analysis models (e.g., RandomForestClassifier), time-series forecasts (e.g., Prophet), and marketing ROI analyses.
*   **Reporting & Visualization:** Conceptual dashboards and reports designed for executive and operational stakeholders to provide actionable insights.
*   **CI/CD:** GitHub Actions orchestrates automated testing, deployment, and continuous data quality enforcement.

## Getting Started

Refer to the `docs/` directory for detailed Standard Operating Procedures (SOPs), project architecture, and key design decisions.

## Repository Structure

```
fcbi-staff-data-analyst-portfolio/
├── .github/                       # GitHub Actions workflows
│   └── workflows/
│       ├── data_ingestion_ci.yml    
│       ├── dbt_ci.yml               
│       └── model_retraining.yml     
├── data/                          # Raw and processed data files
│   ├── raw/                       
│   └── processed/                 
├── notebooks/                     # Exploratory Data Analysis (EDA) and ad-hoc analysis
│   ├── eda_loan_origination.ipynb
│   └── risk_model_development.ipynb
├── src/                           # Python source code
│   ├── data_generation.py         
│   ├── modeling/                  
│   │   └── risk_predictor.py
│   └── utils/                     
├── dbt/                           # dbt project for SQL transformations
│   ├── models/                    
│   │   ├── marts/                 
│   │   ├── intermediate/          
│   │   └── staging/               
│   ├── profiles.yml               
│   └── dbt_project.yml            
├── docs/                          # Project documentation, SOPs, architectural diagrams
│   ├── project_architecture.md
│   ├── sop_data_quality_checks.md
│   ├── sop_data_ingestion.md
│   ├── sop_dbt_model_maintenance.md
│   ├── sop_ad_hoc_data_requests.md
│   └── key_design_decisions.md
├── README.md                      # Project overview, setup instructions
├── requirements.txt               # Python dependencies
├── .gitignore                     # Files/folders to ignore in Git
└── LICENSE                        # Project license
```

