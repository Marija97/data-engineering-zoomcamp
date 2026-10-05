# Module 02 – Workflow Orchestration (Kestra)

This folder contains my Module 2 work for the **DataTalks.Club Data Engineering Zoomcamp (2026 cohort)**.

The focus of this week was workflow orchestration using **Kestra**, building on the Docker and SQL foundations established in Week 1.

---

## Context

After setting up local infrastructure and database ingestion in Week 1, this week introduced orchestration concepts including:

- Parameterized executions
- Variable rendering
- Task-level outputs vs logs

All flows were executed locally using Docker and the Kestra UI.

---

## Key Flow

### `flows/04_postgres_taxi_from_scratch.yaml`

Instead of following the complete solution  `flows/04_postgres_taxi.yaml` provided by the course, I created `flows/04_postgres_taxi_from_scratch.yaml` and built the pipeline step by step on my own. The goal was to better understand how each part works and how the final solution comes together.

The flow performs the following operations:

- Downloads and extracts monthly NYC Taxi CSV data
- Computes the uncompressed CSV file size using a Python task
- Loads data into a PostgreSQL table
- Supports yellow taxi dataset
  
What is to be added:  

- Add idempotent logic to the database load stage
- Support the green taxi dataset, as well as the yellow
  
⬅ [Project repository](https://github.com/AsherJD-io/nyc-taxi-data-platform)
⬅ [Week 1 – Docker & Terraform](https://github.com/AsherJD-io/nyc-taxi-data-platform/tree/main/01-docker-terraform)
