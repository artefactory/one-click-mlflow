#!/bin/bash

set -e

PROJECT_ID=$(jq -r '.TF_VAR_project_id' ../vars.json)
NETWORKS_LIST=$(gcloud --format json compute networks list --project "$PROJECT_ID")
NETWORKS_NAMES="$(echo "$NETWORKS_LIST" | jq -r '.[].name')"
NETWORKS_PROMPTS_RAW='Create new network (recommended)'$'\n'$NETWORKS_NAMES
NETWORKS_OPTIONS_RAW='mlflow-network'$'\n'$NETWORKS_NAMES

IFS=$'\n'
NETWORKS_PROMPTS=(${NETWORKS_PROMPTS_RAW})
NETWORKS_OPTIONS=(${NETWORKS_OPTIONS_RAW})

if echo "${NETWORKS_PROMPTS[@]}" | grep -q "mlflow-network";
then
  NETWORK="mlflow-network"
  echo "=> A dedicated network has already been deployed by a previous run of one-click-mlflow. Using this one."
else
  echo
  echo "What network do you want to attach to?"
  echo

  counter=1
  for CHOICE in "${NETWORKS_PROMPTS[@]}"
  do
    echo [$((counter++))] "$CHOICE"
  done

  MAX_CHOICE=$((counter - 1))
  read -p 'Please enter your numeric choice: ' NUMERIC_CHOICE

  while echo "$NUMERIC_CHOICE" | grep -vqE "^\-?[0-9]+$" || (( NUMERIC_CHOICE < 1 )) || (( NUMERIC_CHOICE > MAX_CHOICE ))
  do
    read -p "Please enter a value between 1 and $MAX_CHOICE: " NUMERIC_CHOICE
  done

  NUMERIC_CHOICE="$(( NUMERIC_CHOICE - 1 ))"

  NETWORK="${NETWORKS_OPTIONS["$NUMERIC_CHOICE"]}"
fi

if [ "$NETWORK" != "mlflow-network" ];
then
  ./save_var.sh TF_VAR_network_name "$NETWORK"
else
  ./save_var.sh TF_VAR_network_name ""
fi
echo