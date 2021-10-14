#!/bin/bash

add_to_json() {
  jq --arg KEY "$1" --arg VALUE "$2" '.[$KEY] = $VALUE' ../cloudbuild/IaC/vars.json > ../cloudbuild/IaC/vars.json.tmp && mv ../cloudbuild/IaC/vars.json.tmp  ../cloudbuild/IaC/vars.json
}

set -e
export LC_CTYPE=C

SALT=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 10 ; echo '')

add_to_json TF_VAR_project_id "one-click-mlflow-ci-$SALT"
add_to_json TF_VAR_folder_id "$1"
add_to_json TF_VAR_billing_account "$2"
add_to_json TF_VAR_birth_project_number "$3"

rm -rf ../cloudbuild/IaC/vars
VARS=$(jq -r '. | to_entries | .[] | .key + "=" + (.value|tostring)' ../cloudbuild/IaC/vars.json)

for VAR in $VARS
do
  echo "export $VAR" >> ../cloudbuild/IaC/vars
done

# Save ocmlf vars
./save_var.sh TF_VAR_project_id "one-click-mlflow-ci-$SALT"
./save_var.sh TF_VAR_backend_bucket "one-click-mlflow-ci-state-$SALT"
./save_var.sh TF_VAR_create_brand 1
./save_var.sh TF_VAR_oauth_client_id ""
./save_var.sh TF_VAR_oauth_client_secret ""
./save_var.sh TF_VAR_network_name ""
./save_var.sh TF_VAR_web_app_users \'[""]\'
./save_var.sh TF_VAR_consent_screen_support_email "$SUPPORT_EMAIL"