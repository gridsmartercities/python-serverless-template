#!/usr/bin/env bash
set -e

function show_help() {
    echo -e "\nUSAGE:\n\t./update-commit-status.sh <CONTEXT> <COMMAND>"
    echo -e "\n\tThis script requires the following environment variables: REPO_NAME, GITHUB_TOKEN, AWS_REGION, CODEBUILD_BUILD_ID\n"
    echo -e "\n\tThe script automatically picks up the current COMMIT SHA"
}

if [[ $# -ne 2 ]]; then
    echo "Invalid arguments"
    show_help
    exit 0
fi

COMMIT=`git rev-parse HEAD`
OWNER="gridsmartercities"

# User Inputs
CONTEXT=$1
COMMAND=$2


function create_commit_status() {
    HUB_RESULT=`/opt/tools/hub/bin/hub api "https://api.github.com/repos/$OWNER/$REPO_NAME/statuses/$COMMIT?access_token=$GITHUB_TOKEN" \
        -H Content-Type:application/json \
        -X POST \
        -f state="$1" \
        -f description="$2" \
        -f context="$CONTEXT" \
        -f target_url="https://$AWS_REGION.console.aws.amazon.com/codebuild/home?region=$AWS_REGION#/builds/$CODEBUILD_BUILD_ID/view/new"`
}

# Create a Pending commit status
create_commit_status "pending" "job starting"

# Execute the command (do not immediately exit on failure)
set +e
$COMMAND
CMD_RESULT=$?
set -e

# Create a Success or Failure commit status
if [[ $CMD_RESULT -ne 0 ]]; then
    create_commit_status "failure" "job failed"
    exit 0
fi

create_commit_status "success" "job succeeded"
exit 0