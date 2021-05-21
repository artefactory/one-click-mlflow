#!/bin/bash

set -e

echo
echo "What contact email address should be displayed when a user trying to log in is not authorized? The address should be yours or a Cloud Identity group managed by you."
echo

read -p "Support email address (probably yours): " SUPPORT_EMAIL

./save_var.sh TF_VAR_consent_screen_support_email "$SUPPORT_EMAIL"