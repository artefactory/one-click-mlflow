#!/bin/bash

if terraform state list module.mlflow.module.server.google_app_engine_application.app 1> /dev/null 2> /dev/null ; then
    app_in_state=1
else
    app_in_state=0
fi

if [ "$app_exists" == 1 ] && [ "$app_in_state" == 0 ]; then
    echo Importing app engine service
    terraform import module.mlflow.module.server.google_app_engine_application.app $TF_VAR_project_id
fi
