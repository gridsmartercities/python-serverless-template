#!/bin/bash

# copy source to build directory
cp -R src .build
# create lambda layer directory
mkdir .build/lambda_layer
# copy full source to lambda layer directory
cp -R src .build/lambda_layer/src
# remove lambda function specific code
rm -rf .build/lambda_layer/src/lambdas
# copy requirements file to lambda layer
mv .build/requirements.txt .build/lambda_layer/requirements.txt
# create any missing requirements files for the lambdas
python tools/build/gen_requirements.py
