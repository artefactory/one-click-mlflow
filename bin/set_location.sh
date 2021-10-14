#!/bin/bash

set -e

echo
echo "In which region do you want to deploy MLFlow ?"
echo

APP_REGIONS_LIST=$(gcloud --format json app regions list)
APP_REGIONS_NAMES=$(echo "$APP_REGIONS_LIST" | jq -r '.[].region')

counter=1
for REGION in $APP_REGIONS_NAMES
do
  echo [$((counter++))] "$REGION"
done

MAX_CHOICE=$((counter - 1))
read -p 'Please enter your numeric choice: ' NUMERIC_CHOICE

while echo "$NUMERIC_CHOICE" | grep -vqE "^\-?[0-9]+$" || (( NUMERIC_CHOICE < 1 )) || (( NUMERIC_CHOICE > MAX_CHOICE ))
do
  read -p "Please enter a value between 1 and $MAX_CHOICE: " NUMERIC_CHOICE
done
echo

APP_ENGINE_REGION="$(echo "$APP_REGIONS_LIST" | jq -r --argjson NUMERIC_CHOICE "$(( NUMERIC_CHOICE - 1 ))" '.[$NUMERIC_CHOICE].region')"

#locations europe-west1 and us-central1 are called europe-west and us-central in APP Engine commands 
if [ $APP_ENGINE_REGION == 'europe-west' ];
    then REGION='europe-west1'
elif [ $APP_ENGINE_REGION == 'us-central' ];
    then REGION='us-central1'
else
    REGION=$APP_ENGINE_REGION
fi

./save_var.sh TF_VAR_location "$REGION"
./save_var.sh TF_VAR_app_engine_location "$APP_ENGINE_REGION"
