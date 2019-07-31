#!/usr/bin/env bash
set -e

function show_help() {
    echo -e "\nUSAGE:\n\t./report-status.sh <REPO_NAME> <COMMIT_SHA> <CONTEXT> <COMMAND>"
}

if [[ $# -ne 4 ]]; then
    echo "Invalid arguments"
    show_help
    exit 0
fi

api_id=`aws apigateway get-rest-apis --query "items[?name=='$1'].id" | jq first | tr -d '"'`
echo https://$api_id.execute-api.$AWS_REGION.amazonaws.com/Prod

exit 0