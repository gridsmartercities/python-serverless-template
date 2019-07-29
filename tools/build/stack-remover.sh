#!/bin/bash
set -e

repo_name=$1-stack-pr-

# get stacks
stack_names=$(aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE --query 'StackSummaries[?contains(StackName, `'$repo_name'`)].StackName' | jq -r '.[]')

# get github's open prs
open_pr_names=$(hub pr list -s open -f %i)
open_pr_names=${open_pr_names#?}
IFS='#' read -ra open_prs <<< "$open_pr_names"

for stack_name in $stack_names
do
    if [[ "${open_prs[@]}" != *"${stack_name//[!0-9]/}"* ]]; then
        # aws cloudformation delete-stack --stack-name $stack_name
        echo "... removed $stack_name"
    fi
done

exit 0