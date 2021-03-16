#!/bin/bash

app_in_state=$(terraform state list module.mlflow.module.server.google_app_engine_application.app | grep "module.mlflow.module.server.google_app_engine_application.app")
if [ "$app_exists" != 0 ] && [ "$app_in_state" == "" ]; then
    echo Importing app engine service
    terraform import module.mlflow.module.server.google_app_engine_application.app $TF_VAR_project_id
fi
