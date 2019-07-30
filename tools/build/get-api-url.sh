#!/bin/bash
set -e

function show_help() {
    echo -e "\nUSAGE:\n\t./get-api-url.sh <API_NAME>"
}

if [[ $# -eq 0 ]]; then
    echo "No arguments supplied"
    show_help
    exit 1
fi

api_id=`aws apigateway get-rest-apis --query "items[?name=='$1'].id" | jq first | tr -d '"'`
echo https://$api_id.execute-api.$AWS_REGION.amazonaws.com/Prod

exit 0