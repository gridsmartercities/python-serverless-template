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

REPO_NAME=$1
COMMIT_SHA=$2
CONTEXT=$3
COMMAND=$4

function create_commit_status() {
    echo "creating commit status $1 $2 $3 $4 $5"
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
create_commit_status $REPO_NAME $COMMIT_SHA $STATE $DESCRIPTION $CONTEXT

exit 0