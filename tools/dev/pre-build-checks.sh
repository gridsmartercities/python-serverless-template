#!/bin/bash

function show_failure() {
    echo -e "\n... FAILED!\n"
    exit 1
}

echo "... validating sam template"
if [[ ! $(aws cloudformation validate-template --template-body file://template.yaml) ]]; then
    show_failure
fi

echo "... checking sam template"
cfn-lint template.yaml
if [[ $? != 0 ]]; then
    show_failure
fi

echo "... validating OpenApi specification"
if [[ ! $(swagger-cli validate api-contract.yaml) ]]; then
    show_failure
fi

echo "... running prospector tools"
if ! prospector; then
    show_failure
fi

echo "... running security tests"
bandit -r -q .
if [[ $? != 0 ]]; then
    show_failure
fi

echo "... running unit tests"
coverage run --branch --source='.' -m unittest tests/test_*.py
if [[ $? != 0 ]]; then
    show_failure
fi
coverage run --branch --source='.' -m unittest tests/*/test_*.py
if [[ $? != 0 ]]; then
    show_failure
fi

echo "... checking coverage"
coverage report -m --fail-under=100 --omit=tests/*,it/*
if [[ $? != 0 ]]; then
    show_failure
fi

echo -e "\n... SUCCESS!\n"

exit 0