#!/usr/bin/env bash

set -e

function show_help() {
    echo -e "\nUSAGE:\n\t./run-prod-build.sh <ROLE_ARN> <PROJECT_ARN>"
}

if [[ $# -ne 2 ]]; then
    echo "Invalid arguments"
    show_help
    exit 0
fi

role_arn=$1
project_arn=$2

RESULT=$(aws sts assume-role --role-arn $role_arn --role-session-name StgBuildSession --output text)

export AWS_ACCESS_KEY_ID=$(echo $RESULT | awk '{print $5}')
export AWS_SECRET_ACCESS_KEY=$(echo $RESULT | awk '{print $7}')
export AWS_SESSION_TOKEN=$(echo $RESULT | awk '{print $8}')

aws codebuild start-build --project-name $project_arn
