#!/bin/bash

set -e

CODE=0

if ! terraform -v 1>/dev/null;
then
  CODE=1
  echo "It seems you do not have Terraform installed. Install it and make sure it's in your path then try again."
fi

if ! jq --version 1>/dev/null;
then
  CODE=1
  echo "It seems you do not have jq installed. Install it and make sure it's in your path then try again."
fi

exit "$CODE"