#!/usr/bin/env bash

set -e

function show_help() {
    echo -e "\nUSAGE:\n\t./run-prod-build.sh <PROD_ACCOUNT_ID> <SERVICE_NAME> <PROD_BUILD_REGIONS>"
}

if [[ $# -ne 3 ]]; then
    echo "Invalid arguments"
    show_help
    exit 0
fi

account_id=$1
service_name=$2
regions=$3

access_key=$AWS_ACCESS_KEY_ID
secret_key=$AWS_SECRET_ACCESS_KEY
token=$AWS_SESSION_TOKEN

for region in $(echo $regions | sed "s/,/ /g")
do
    RESULT=$(aws sts assume-role --role-arn arn:aws:iam::$account_id:role/$service_name-$region-prod-codebuild-service-role --role-session-name StgBuildSession --output text)

    export AWS_ACCESS_KEY_ID=$(echo $RESULT | awk '{print $5}')
    export AWS_SECRET_ACCESS_KEY=$(echo $RESULT | awk '{print $7}')
    export AWS_SESSION_TOKEN=$(echo $RESULT | awk '{print $8}')

    aws codebuild start-build --project-name arn:aws:codebuild:$region:$account_id:project/$service_name-prod --region $region

    # back to original permissions, so we can run the next entry in the loop
    export AWS_ACCESS_KEY_ID=$access_key
    export AWS_SECRET_ACCESS_KEY=$secret_key
    export AWS_SESSION_TOKEN=$token
done