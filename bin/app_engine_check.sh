#!/bin/bash

if gcloud app versions list 1> /dev/null 2> /dev/null ; then
  DEPLOYED_VERSIONS=$(gcloud --format json app versions list | jq '.[] | select(.service=="default") | .id')
else
  DEPLOYED_VERSIONS=""
fi

if [[ "$DEPLOYED_VERSIONS" == *"mlflow-default"* ]] || [[ "$DEPLOYED_VERSIONS" == "" ]]; then
  echo 1
else
  echo 0
fi