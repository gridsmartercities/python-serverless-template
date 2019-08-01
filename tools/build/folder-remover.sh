#!/bin/bash
set -e

function show_help() {
    echo -e "\nUSAGE:\n\t./folder-remover.sh <FOLDER_SUBSTR>\tIt will remove all folders where name contains <FOLDER_SUBSTR>"
    echo -e "\n\tThis script requires the following environment variables: SAM_S3_BUCKET\n"
}

if [[ $# -ne 1 ]]; then
    echo "Invalid argument"
    show_help
    exit 0
fi

folder_substr=$1

# get github's open prs
open_prs=$(hub pr list -s open -f %i)
IFS='#' read -ra open_prs <<< "${open_prs#?}"

# get aws s3 folders inside the SAM_S3_BUCKET bucket where folder name contains FOLDER_SUBSTR
folders=$(aws s3 ls s3://$SAM_S3_BUCKET/$folder_substr | tr -d 'PRE \n')
IFS='/' read -ra folders <<< "$folders"

# delete folders one by one
for folder in "${folders[@]}"
do
    if [[ "${open_prs[@]}" != *"${folder//[!0-9]/}"* ]]; then
        aws s3 rm s3://$SAM_S3_BUCKET/$folder --recursive
        echo "... removed s3://$SAM_S3_BUCKET/$folder folder"
    fi
done

exit 0