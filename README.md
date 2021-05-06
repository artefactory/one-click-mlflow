# 1. one-click-mlflow
A tool to deploy a mostly serverless MLflow on a GCP project with one command

- [1. one-click-mlflow](#1-one-click-mlflow)
  - [1.1. How to use](#11-how-to-use)
    - [1.1.1. Pre-requesites](#111-pre-requesites)
    - [1.1.2. Deploying](#112-deploying)
    - [1.1.3. What it does](#113-what-it-does)
    - [1.1.4. Other available make commands](#114-other-available-make-commands)
    - [1.1.5. Pushing logs and artifacts](#115-pushing-logs-and-artifacts)


## 1.1. How to use

### 1.1.1. Pre-requisites
- A GCP project on which you are owner
- Terraform and jq installed
- Initialized gcloud SDK with your owner account

### 1.1.2. Deploying
Run `make one-click-mlflow` and let the wizard guide you.


### 1.1.3. What it does
- Enables the necessary services
- Builds and deploys the MLFlow docker image
- Creates a private IP CloudSQL (MySQL) database for the tracking server
- Creates an AppEngine Flex  on the default service for the web UI, secured by IAP
- Manages all the network magic
- Creates the `mlflow-log-pusher` service account

### 1.1.4. Other available make commands
- `make deploy`: builds and pushes the application image and (re)deploys the infrastructure
- `make docker`: builds and pushes the application image
- `make apply`: (re)deploys the infrastructure
- `make destroy`: destroys the infrastructure. **Will not delete the OAuth consent screen, and the app engine application**.


### 1.1.5. Pushing your first parameters, logs, artifacts
Once the deployment successful, you can start pushing to your MLFlow instance.

```bash
cd examples
python3 -m venv venv 
source venv/bin/activate
pip install -r requirements.txt
python track_experiment.py
```

You can than adapt `examples/track_experiment.py` and `examples/mlflow_config.py` to suit your application's needs.