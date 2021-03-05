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
