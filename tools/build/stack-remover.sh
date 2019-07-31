#!/bin/bash
set -e

function show_help() {
    echo -e "\nUSAGE:\n\t./stack-remover.sh <STACK_SUBSTR>\tIt will remove all stacks where name contains <STACK_SUBSTR>"
}

if [[ $# -ne 1 ]]; then
    echo "Invalid argument"
    show_help
    exit 0
fi

# get github's open prs
open_pr_names=$(/opt/tools/hub/bin/hub pr list -s open -f %i)
open_pr_names=${open_pr_names#?}
IFS='#' read -ra open_prs <<< "$open_pr_names"

# get aws stacks where stack name contains STACK_SUBSTR
stack_names=$(aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE UPDATE_COMPLETE --query 'StackSummaries[?contains(StackName, `'$1'`)].StackName' | jq -r '.[]')

for stack_name in $stack_names
do
    if [[ "${open_prs[@]}" != *"${stack_name//[!0-9]/}"* ]]; then
        aws cloudformation delete-stack --stack-name $stack_name
        echo "... removed $stack_name"
    fi
done

exit 0