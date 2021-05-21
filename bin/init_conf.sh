#!/bin/bash

set -e

if [[ ! -e ../vars.json ]]; then
  echo '{"TF_VAR_web_app_users":[]}' > ../vars.json
fi