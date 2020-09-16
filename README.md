# one-click-mlflow
A tool to deploy a mostly serverless MLflow on a GCP project with one command

## Goals

The project's deliverables are
- MLflow tracking server on Cloud Run
- Artifacts on GCS
- Metrics backend on Cloud SQL (MySQL)
- Terraformed infrastructure
- A list of all the GCP APIs that need to be enabled
- A list of all the necessary GCP permissions to run the deployment


# Prerequesites


- Create backend bucket to store terraform state
- Enable google apis (serverless vpc access)

To do so, just run make pre-requesites