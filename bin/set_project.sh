#!/bin/bash

set -e

echo
echo "What project do you want to deploy MLFlow on?"
echo

PROJECT_LIST=$(gcloud --format json projects list)
PROJECT_IDS=$(echo "$PROJECT_LIST" | jq -r '.[].projectId')

counter=1
for PROJECT in $PROJECT_IDS
do
  echo [$((counter++))] "$PROJECT"
done

MAX_CHOICE=$((counter - 1))
read -p 'Please enter your numeric choice: ' NUMERIC_CHOICE

while echo "$NUMERIC_CHOICE" | grep -vqE "^\-?[0-9]+$" || (( NUMERIC_CHOICE < 1 )) || (( NUMERIC_CHOICE > MAX_CHOICE ))
do
  read -p "Please enter a value between 1 and $MAX_CHOICE: " NUMERIC_CHOICE
done
echo


PROJECT_ID="$(echo "$PROJECT_LIST" | jq -r --argjson NUMERIC_CHOICE "$(( NUMERIC_CHOICE - 1 ))" '.[$NUMERIC_CHOICE].projectId')"
PROJECT_NUMBER=$(gcloud --format json projects describe "$PROJECT_ID" | jq '.["projectNumber"]' | tr -d '"')

gcloud config set project "$PROJECT_ID"
./save_var.sh TF_VAR_project_id "$PROJECT_ID"
./save_var.sh TF_VAR_project_number "$PROJECT_NUMBER"
./save_var.sh TF_VAR_backend_bucket "$PROJECT_ID-$PROJECT_NUMBER-ocmlf-state"