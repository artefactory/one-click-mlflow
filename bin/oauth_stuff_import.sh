#!/bin/bash

set -e

PROJECT_ID=$(jq -r '.TF_VAR_project_id' ../vars.json)
PROJECT_NUMBER=$(jq -r '.TF_VAR_project_number' ../vars.json)
APP_EXISTS=$(jq -r '.APP_EXISTS' ../vars.json)

if cd ../IaC && terraform state list module.mlflow.module.server.google_app_engine_application.app 1> /dev/null 2> /dev/null; then
    app_in_state=1
else
    app_in_state=0
fi
cd ../bin

if cd ../IaC && terraform state list module.mlflow.module.server.google_iap_brand.project_brand 1> /dev/null 2> /dev/null; then
    brand_in_state=1
else
    brand_in_state=0
fi
cd ../bin

if cd ../IaC && terraform state list module.mlflow.module.server.google_iap_client.project_client 1> /dev/null 2> /dev/null; then
    client_in_state=1
else
    client_in_state=0
fi
cd ../bin

if gcloud alpha iap oauth-brands list | grep "name: " 1> /dev/null 2> /dev/null && [ "$brand_in_state" == 0 ]; then
  echo "=> A consent screen (brand) has already been configured on this project. It will be used as-is"
  BRAND_EXISTS=1
  BRAND_NAME="projects/$PROJECT_NUMBER/brands/$PROJECT_NUMBER"

  ./save_var.sh TF_VAR_brand_name "$BRAND_NAME"
  ./save_var.sh TF_VAR_create_brand 0
else
  if [ "$brand_in_state" == 0 ];
  then
    echo "=> No consent screen (brand) has been configured on this project, a new one will be created"
    echo "=> No oauth client exists on this project. A new one will be created"
  fi

  BRAND_EXISTS=0

  ./save_var.sh TF_VAR_create_brand 1
  ./save_var.sh TF_VAR_oauth_client_id ""
  ./save_var.sh TF_VAR_oauth_client_secret ""
fi


if [ $BRAND_EXISTS == 1 ]; then
  CLIENT_DESCRIPTION=$(gcloud --format json alpha iap oauth-clients list "$BRAND_NAME")

  if [ "$CLIENT_DESCRIPTION" != '[]' ] && [ "$client_in_state" == 0 ]; then
    echo "=> An oauth client has already been created on this project. It will be used for IAP access"
    OAUTH_CLIENT_ID=$(echo "$CLIENT_DESCRIPTION" | jq '.[0].name' | tr -d '"' | sed 's:.*/::')
    OAUTH_CLIENT_SECRET=$(echo "$CLIENT_DESCRIPTION" | jq '.[0].secret' | tr -d '"')

    ./save_var.sh TF_VAR_oauth_client_id "$OAUTH_CLIENT_ID"
    ./save_var.sh TF_VAR_oauth_client_secret "$OAUTH_CLIENT_SECRET"

  else
    if [ "$client_in_state" == 0 ];
    then
      echo "=> No oauth client exists on this project. A new one will be created"
    fi

    ./save_var.sh TF_VAR_oauth_client_id ""
    ./save_var.sh TF_VAR_oauth_client_secret ""
  fi
fi

if [ "$APP_EXISTS" == 1 ] && [ "$app_in_state" == 0 ]; then
  echo Importing app engine service
  cd .. && source vars && cd bin
  cd ../IaC && terraform import module.mlflow.module.server.google_app_engine_application.app "$PROJECT_ID" && cd ../bin
fi
echo