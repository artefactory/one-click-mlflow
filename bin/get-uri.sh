#!/bin/bash

set -e

APP_DESCRIBE=$(gcloud --format json app describe) 
APP_DEFAULT_URI=$(echo "$APP_DESCRIBE" | jq -r '.defaultHostname')

./save_var.sh APP_DEFAULT_URI "$APP_DEFAULT_URI"
