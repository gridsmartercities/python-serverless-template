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


## Set up

1. Create a Github repo by clicking on the Github template button above.
2. Create your AWS account.
3. Run the cloudformation stack to setup the CI/CD process in your AWS account.
4. Start writing your code!





Note: set chmod u+x on pre-push and packager!!
