# python-serverless-template

This is a Github Template to generate Serverless APIs in Python using AWS SAM. 

The template makes use of:

- OpenApi 3.0 for defining the API contract.
- The Swagger CLI to validate the OpenAPI specification.
- AWS SAM for the AWS resourses specification.
- AWS cloudformation to setup CI/CD in your AWS account.
- The Python unittest package for unit testing.
- Coverage, to ensure the Python code is 100% unit tested
- Prospector, a python tool that checks code quality.
- pylint_quotes, a pylint plugin to ensure a consistent Python quotation style.
- Bandit, a security testing Python tool
- Dredd, for contract testing against the OpenAPI definition, with hooks written in Python.


## Project Set up

1. Create a Github repo by clicking on the Github template button above.
2. Create your AWS account.
3. Run the cloudformation stack to setup the CI/CD process in your AWS account.

## Developer Set up

1. Clone your new repo locally
2. Create a Python virtual environment
3. Install the development requirements by running "pip install -r requirements.txt"
4. Start writing your code!

Additionally, you can:

1. Set a pre-push Git hook to run all checks before any code is pushed to Github:
    - copy pre-push script to .git/hooks folder (cp pre-push .git/hooks) folder
    - give execute permissions to pre-push script by running chmod u+x .git/hooks/pre-push
    


Note: set chmod u+x on pre-push and packager!!

