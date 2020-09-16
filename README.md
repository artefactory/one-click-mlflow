# one-click-mlflow
A tool to deploy a mostly serverless MLflow on a GCP project with one command

## How to use

### Pre-requesites
- Create a GCP project
- Init gcloud
- Have docker installed locally
- Export the name of your GCP project by running `EXPORT PROJECT_ID=YOUR_PROJECT`
- Run `make pre-requesites`. You'll be asked to enter the bucket name used to store terraform state, and your project id
- Deploy mlflow container by running `make docker`. This will build mlflow docker image locally and push it to container registry

### Deploy mlflow
- Export the name of your GCP project by running `EXPORT PROJECT_ID=YOUR_PROJECT`
- Export the name of your bucket used to store terraform state by running `EXPORT BACKEND_TERRAFORM=BUCKET_NAME`. It must be the same as the one you selected when installing the pre-requesites.
- Deploy mlflow to GCP by running `make apply`. You'll be asked to enter the database password you want to use


## Goals

The project's deliverables are
- MLflow tracking server on Cloud Run
- Artifacts on GCS
- Metrics backend on Cloud SQL (MySQL)
- Terraformed infrastructure
- A list of all the GCP APIs that need to be enabled
- A list of all the necessary GCP permissions to run the deployment
