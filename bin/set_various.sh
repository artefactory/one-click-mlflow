#!/bin/bash

set -e

PROJECT_ID=$(jq -r '.TF_VAR_project_id' ../vars.json)
DOCKER_REPO="eu.gcr.io"
DOCKER_NAME="mlflow"
DOCKER_TAG="0.1"

./save_var.sh DOCKER_REPO "$DOCKER_REPO"
./save_var.sh DOCKER_NAME "$DOCKER_NAME"
./save_var.sh DOCKER_TAG "$DOCKER_TAG"
./save_var.sh TF_VAR_mlflow_docker_image "$DOCKER_REPO/$PROJECT_ID/$DOCKER_NAME:$DOCKER_TAG"

# app_exists will be true if the module.mlflow.server.google_app_engine_application.app resource exists
if gcloud app describe 1> /dev/null 2> /dev/null ; then
    ./save_var.sh  APP_EXISTS 1
else
    ./save_var.sh  APP_EXISTS 0
fi
