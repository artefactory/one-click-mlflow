#!/bin/bash

if gcloud app versions list 1> /dev/null 2> /dev/null ; then
  DEPLOYED_VERSIONS=$(gcloud --format json app versions list | jq '.[] | select(.service=="default") | .id')
else
  DEPLOYED_VERSIONS=""
fi

if [[ "$DEPLOYED_VERSIONS" == *"mlflow-default"* ]] || [[ "$DEPLOYED_VERSIONS" == "" ]]; then
  echo "A dummy app engine with the name default will be created"
  echo export TF_VAR_create_default_service=1 >> ../vars_additionnal
else
  echo export TF_VAR_create_default_service=0 >> ../vars_additionnal
fi