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

### 1.1.1. Pre-requesites
- A GCP project on which you are owner
- Terraform > 0.13.2 installed
- Initialized gcloud SDK with your owner account
- Docker engine running with rights to push to container registry (You can just run `gcloud auth configure-docker`)
- Install jq, for example with `brew install jq`

### 1.1.2. Deploying
Fill out the `vars` file.

|Variable name|Description|
|---|---| 
|`TF_VAR_project_id`|ID of the GCP project (not necessarily the same as the projet name)|
|`TF_VAR_backend_bucket`|Name of the terraform backend bucket to be created. Should be globally unique. No `gs://` prefix|
|`TF_VAR_web_app_users`|List of authorized users/groups/domains. Should be a single quoted list of string such as '["user:jane@example.com", "group:people@example.com", "domain:example.com"]'. Email addresses and domains must be associated with an active Google Account, G Suite account, or Cloud Identity account.|
|`TF_VAR_network_name`|The network the application and backend should attach to. If left blank, a new network will be created. Hint: unless otherwise specified, a network named "default" will already exist on the project. To plug into this network, type TF_VAR_network_name=default into this variable.|
|`TF_VAR_consent_screen_support_email`|Contact email address displayed by the SSO screen when the user trying to log in is not authorized. The address should be that of the user deploying mlflow (you) or a Cloud Identity group managed by this user. If you have already set-up your consent screen on the GCP project you can leave it blank|

**Run `make one-click-mlflow` and follow the prompts.**


### 1.1.3. What it does
- Enables the necessary services
- Builds and pushes the MLFlow docker image
- Creates a private IP CloudSQL (MySQL) database for the tracking server
- Creates an AppEngine Flex  on the default service for the web UI, secured by IAP
- Manages all the network magic
- Creates the `mlflow-log-pusher` service account

### 1.1.4. Other available make commands
- `make deploy`: builds and pushes the application image and (re)deploys the infrastructure
- `make docker`: builds and pushes the application image
- `make apply`: (re)deploys the infrastructure
- `make destroy`: destroys the infrastructure. **Will not delete the OAuth consent screen, and the app engine application**. If you destroy it and wants to redeploy on the same project, don't forget to set up `TF_VAR_oauth_client_id` and `TF_VAR_oauth_client_secret` instead of `TF_VAR_consent_screen_support_email`


### 1.1.5. Pushing logs and artifacts
Firstly create a python virtual environment to run your project and install mlflow and google-auth-oauthlib:

- `python3 -m venv venv && source venv/bin/activate && pip install google-auth-oauthlib mlflow`

You will need to specify the project id hosting the tracking server and the name of your MLFlow experiment:
- `export PROJECT_ID=<my_mlflow_gcp_project>`
- `export EXPERIMENT_NAME=<my_experiement>`

You may also need to get a service account key for `mlflow-log-pusher` if you lack the necessary permissions:
- `export GOOGLE_APPLICATION_CREDENTIALS=secrets/<my_key.json>`

You can now make your initial push of metrics by executing:
- ```python examples/track_experiment.py```

To be able to push logs and artifacts to the tracking server, you will need to authenticate your request.
Simply paste the following snippet in your `config.py` or `__init__.py`.

````python
import os

import six
from mlflow import set_tracking_uri, set_experiment
from google.auth.transport.requests import Request
from google.oauth2 import id_token
import requests


def _get_client_id(service_uri):
    redirect_response = requests.get(service_uri, allow_redirects=False)
    if redirect_response.status_code != 302:
        print(f"The URI {service_uri} does not seem to be a valid AppEngine endpoint.")
        return None

    redirect_location = redirect_response.headers.get("location")
    if not redirect_location:
        print(f"No redirect location for request to {service_uri}")
        return None

    parsed = six.moves.urllib.parse.urlparse(redirect_location)
    query_string = six.moves.urllib.parse.parse_qs(parsed.query)
    return query_string["client_id"][0]


PROJECT_ID = os.environ["PROJECT_ID"]
EXPERIMENT_NAME = os.environ["EXPERIMENT_NAME"]

# If mlflow if not deployed on the default app engine service, change it with the url of your service <!-- omit in toc --> 
tracking_uri = f"https://{PROJECT_ID}.ew.r.appspot.com/"
client_id = _get_client_id(tracking_uri)
open_id_connect_token = id_token.fetch_id_token(Request(), client_id)
os.environ["MLFLOW_TRACKING_TOKEN"] = open_id_connect_token

set_tracking_uri(tracking_uri)
set_experiment(EXPERIMENT_NAME)
````

You shoud then be able to push logs and artifacts with:
```python
import os
import mlflow

# Log a parameter (key-value pair)
mlflow.log_param("param1", 42)

# Log a metric; metrics can be updated throughout the run
mlflow.log_metric("foo", 42 + 1)
mlflow.log_metric("foo", 42 + 2)
mlflow.log_metric("foo", 42 + 3)

# Log an artifact (output file)
mlflow.log_artifact("artifact_file_path")

```
