#!/bin/bash

set -e

OPTIND=1         # Reset in case getopts has been used previously in the shell.

function show_help() {
    echo -e "\nUSAGE:\n\t./test.sh -h\n\t./test.sh tests.a_lambda.test_a_lambda.ALambdaTests.test_success\n\t./test.sh tests.a_lambda.test_a_lambda.ALambdaTests\n\t./test.sh tests.a_lambda.test_a_lambda\n\nOPTIONS:\n\t-h\tShow help\n"
}

while getopts "h?:" opt; do
    case "$opt" in
        h)
            show_help
            exit 0
            ;;
    esac
done

shift $((OPTIND-1))

[ "${1:-}" = "--" ] && shift

if [[ $# == 0 ]]; then
    show_help
    exit 0
fi

python -m unittest $1