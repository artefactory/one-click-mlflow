#!/bin/bash

if [ "$app_exists" != 0 ]; then
    echo Importing app engine service
    terraform import module.mlflow.module.server.google_app_engine_application.app $TF_VAR_project_id
fi
