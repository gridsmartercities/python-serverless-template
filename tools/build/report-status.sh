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

CONTEXT=$3
COMMAND=$4

URL="https://api.github.com/repos/$1/statuses/$2?access_token=$GITHUB_TOKEN"
TARGET_URL="https://$AWS_REGION.console.aws.amazon.com/codebuild/home?region=$AWS_REGION#/builds/$CODEBUILD_BUILD_ID/view/new"
HEADERS="Content-Type: application/json"


function create_commit_status() {
    PAYLOAD="{\"state\": \"$1\", \"description\": \"$2\", \"context\": \"$3\", \"target_url\": \"$TARGET_URL\"}"
    echo curl $URL -H $HEADERS -X POST -d $PAYLOAD
}

# Create a Pending commit status
create_commit_status $REPO_NAME $COMMIT_SHA "pending" "job starting" $CONTEXT

STATE="success"
DESCRIPTION="job succeeded"

# Execute the command (do not immediately exit on failure)
set +e
$COMMAND
if [[ $? -ne 0 ]]; then
    STATE="failure"
    DESCRIPTION="job failed"
fi
set -e

# Create a Success or Failure commit status
create_commit_status $STATE $DESCRIPTION $CONTEXT

exit 0