#!/bin/bash

set -e

add_access () {
  counter=1
  for CHOICE in "${CHOICES[@]}"
  do
    echo [$((counter++))] "$CHOICE"
  done

  MAX_CHOICE=$((counter - 1))
  read -p 'Please enter your numeric choice: ' NUMERIC_CHOICE

  while (( $NUMERIC_CHOICE < 1 )) || (( $NUMERIC_CHOICE > $MAX_CHOICE ))
  do
    read -p "Please enter a value between 1 and $MAX_CHOICE: " NUMERIC_CHOICE
  done
  NUMERIC_CHOICE="$(( $NUMERIC_CHOICE - 1 ))"
}

echo
echo "Who do you want to give access to MLFlow?"
echo

CHOICES=('Add a user like jane@example.com' 'Add a group like people@example.com' 'Add a domain like example.com' 'Done')
PROMPTS=('Enter the user'\''s address' 'Enter the groups'\''s address' 'Enter the domain'\''s name' '')
GRANT_TYPES=('user' 'group' 'domain')
WEB_APP_USERS=()

while [[ $SELECTED != 'Done' ]]
do
  add_access
  SELECTED="${CHOICES[$NUMERIC_CHOICE]}"
  if [[ $SELECTED != 'Done' ]]
  then
    read -p "${PROMPTS[$NUMERIC_CHOICE]}: " TO_ADD
    WEB_APP_USERS[${#WEB_APP_USERS[@]}]=\"${GRANT_TYPES[$NUMERIC_CHOICE]}:$TO_ADD\"
    echo
  fi
done

IFS=',';WEB_APP_USERS=\'[${WEB_APP_USERS[*]}]\';IFS=$' \t\n'

./save_var.sh TF_VAR_web_app_users $WEB_APP_USERS