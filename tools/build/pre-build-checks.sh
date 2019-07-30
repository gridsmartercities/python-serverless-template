#!/bin/bash


echo "... validating sam template"
if [[ ! $(aws cloudformation validate-template --template-body file://template.yaml) ]]; then
    exit 1
fi

echo "... checking sam template"
cfn-lint template.yaml
if [[ $? != 0 ]]; then
    exit 1
fi

echo "... validating OpenApi specification"
if [[ ! $(swagger-cli validate api-contract.yaml) ]]; then
    exit 1
fi

echo "... running prospector tools"
if ! prospector; then
    exit 1
fi

echo "... running security tests"
bandit -r -q .
if [[ $? != 0 ]]; then
    exit 1
fi

echo "... running unit tests"
coverage run --branch --source='.' -m unittest tests/test_*.py
if [[ $? != 0 ]]; then
    exit 1
fi
coverage run --branch --source='.' -m unittest tests/*/test_*.py
if [[ $? != 0 ]]; then
    exit 1
fi

echo "... checking coverage"
coverage report -m --fail-under=100 --omit=tests/*,it/*
if [[ $? != 0 ]]; then
    exit 1
fi

exit 0