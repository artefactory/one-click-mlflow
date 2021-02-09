#!/bin/bash

if [ "$TF_VAR_nb_app_engine_services" != "0" ]; then
    echo Importing app engine service
    terraform import module.mlflow.module.server.google_app_engine_application.app $TF_VAR_project_id
fi
