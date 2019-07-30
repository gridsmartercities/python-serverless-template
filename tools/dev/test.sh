#!/bin/bash
set -e

function show_help() {
    echo -e "\nUSAGE:\n\t./test.sh tests.a_lambda.test_a_lambda.ALambdaTests.test_success\n\t./test.sh tests.a_lambda.test_a_lambda.ALambdaTests\n\t./test.sh tests.a_lambda.test_a_lambda"
}

if [[ $# == 0 ]]; then
    show_help
    exit 0
fi

python -m unittest $1