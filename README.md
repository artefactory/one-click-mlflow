# one-click-mlflow
A tool to deploy a mostly serverless MLflow on a GCP project with one command

## How to use

### Pre-requesites
- A GCP project
- Initialized gcloud SDK
- Docker engine running

### Deploying
Fill out the `vars` file.


|Variable name|Description|
|---|---| 
|`TF_VAR_project_id`|Name of the GCP project|
|`TF_VAR_backend_bucket`|Name of the terraform backend bucket. Should be unique. No `gs://` prefix|
|`TF_VAR_consent_screen_support_email`|Contact email address displayed by the SSO screen when the user trying to log in is not authorized|
|`TF_VAR_web_app_users`|List of authorized users/groups/domains. Should be a single quoted list of string such as '["user:jane@example.com", "group:people@example.com", "domain:example.com"]'|
|`TF_VAR_network_name`|The network the application and backend should attach to. If blank, a new network will be created.|


Run `make one-clic-mlflow` and follow the prompts.


