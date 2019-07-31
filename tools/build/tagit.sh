#!/usr/bin/env bash
set -e

function show_help() {
    echo -e "\nUSAGE:\n\t./tagit.sh <COMMIT_SHA> <CONTEXT> <COMMAND>"
    echo -e "\n\tThis script requires the following environment variables: REPO_NAME, GITHUB_TOKEN, AWS_REGION, CODEBUILD_BUILD_ID\n"
}

if [[ $# -ne 3 ]]; then
    echo "Invalid arguments"
    show_help
    exit 0
fi

OWNER="gridsmartercities"
# User Inputs
COMMIT=$1
CONTEXT=$2
COMMAND=$3


function create_commit_status() {
    /opt/tools/hub/bin/hub api "https://api.github.com/repos/$OWNER/$REPO_NAME/statuses/$COMMIT?access_token=$GITHUB_TOKEN" \
        -H Content-Type:application/json \
        -X POST \
        -f state="$1" \
        -f description="$2" \
        -f context="$CONTEXT" \
        -f target_url="https://$AWS_REGION.console.aws.amazon.com/codebuild/home?region=$AWS_REGION#/builds/$CODEBUILD_BUILD_ID/view/new"
}

# Create a Pending commit status
create_commit_status "pending" "job starting"

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
create_commit_status "$STATE" "$DESCRIPTION"

exit 0