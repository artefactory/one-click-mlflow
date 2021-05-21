#!/bin/bash

set -e

if gcloud app versions list 1> /dev/null 2> /dev/null ; then
  DEPLOYED_VERSIONS=$(gcloud --format json app versions list | jq '.[] | select(.service=="default") | .id')
else
  DEPLOYED_VERSIONS=""
fi

if [[ "$DEPLOYED_VERSIONS" == "" ]]; then
  echo "=> A dummy app engine with the name \"default\" will be created"
  ./save_var.sh TF_VAR_create_default_service 1
elif [[ "$DEPLOYED_VERSIONS" == *"mlflow-default"* ]]; then
  ./save_var.sh TF_VAR_create_default_service 1
else
  ./save_var.sh TF_VAR_create_default_service 0
fi