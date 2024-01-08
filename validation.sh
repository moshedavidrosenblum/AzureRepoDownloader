#!/bin/bash

function validate_api {
    local project="name-of-project"
    local pat=$1
    local encodedPat=$(printf "%s"":$pat" | base64)
    local apiUrl="$azure_devops_url/$organization/$project/_apis/git/repositories?api-version=6.0"

    local response=$(curl -s -X GET -H "Authorization: Basic $encodedPat" -H "Content-Type: application/json" $apiUrl)

    if [[ -z "$response" || "$response" == *"error"* ]]; then
        echo -e "\033[0;31m############# API validation failed #############\033[0m"
        exit 1
    else
        echo -e "\033[0;32m ############# API validation succeeded #############\033[0m"
    fi
}
