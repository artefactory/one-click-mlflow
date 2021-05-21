#!/bin/bash

set -e

jq --arg KEY "$1" --arg VALUE "$2" '.[$KEY] = $VALUE' ../vars.json > ../vars.json.tmp && mv ../vars.json.tmp ../vars.json

rm -rf ../vars
VARS=$(jq -r '. | to_entries | .[] | .key + "=" + (.value|tostring)' ../vars.json)

for VAR in $VARS
do
  echo "export $VAR" >> ../vars
done