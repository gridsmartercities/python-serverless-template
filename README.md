[<img align="right" alt="Grid Smarter Cities" src="https://s3.eu-west-2.amazonaws.com/open-source-resources/grid_smarter_cities_small.png">](https://www.gridsmartercities.com/)

![Build Status][build-status]
[![License: MIT][mit-license-svg]][mit-license]
![Github Release][release]

# python-serverless-template

We believe Serverless technologies in general, and AWS Serverless in particular, are great. The barrier to entry, however, can be high and setting up a Python project can take a bit of effort.

This is a Github Template to generate Serverless APIs (and more) in Python using AWS SAM with hopefully minimum effort, so you can concentrate on writing your API's business logic pretty much from the start.
 
This template does not use the fantastic [Serverless Framework][serverless-framewor]. You might want to look at it too.

The template is opinionated, and makes use of:

- [AWS SAM][sam] for the AWS resourses specification.
- [AWS cloudformation][cloudformation] to setup CI/CD in your AWS account.
- [OpenApi 3][openapi-3] for defining the API contract.
- The [Swagger CLI][swagger-cli] to validate the OpenAPI specification.
- The Python [unittest][unittest] library for unit testing.
- [Coverage][coverage], to ensure the Python code is 100% unit tested
- [Prospector][prospector], a python tool to check code quality.
- [pylint_quotes][pylint-quotes], a [pylint][pylint] plugin to ensure a consistent Python quotation style throughout the project.
- [Bandit][bandit], a security testing tool
- [Dredd][dredd], for contract testing against the OpenAPI definition, with hooks written in Python.
- A custom packaging tool to ease the sharing of code between lambdas.


## Project Set up

1. Create a Github repo by clicking on the Github template button above.
2. Create an AWS account if you don't have one already.
3. Run the cloudformation stack to setup the CI/CD process in your AWS account (AWS codebuild has a [cost][codebuild-cost])
    a. cloudformation
    b. permissions
    c. Update the Github webhooks
4. To stop contributors from committing code directly to the master branch, setup a master branch protection rule in github. Only Peer reviewed, approved Pull Requests will be allowed to be merged into the master branch. Be aware that, at the time of writing, setting up branch protection in Github has a cost. 

## Developer Set up

To follow these instructions, you will need to be familiar with pip, and creating and managing Python virtual environments. If you are not, take a look at [this](https://packaging.python.org/guides/installing-using-pip-and-virtual-environments/).

1. Clone your new repo locally
2. Create a Python virtual environment
3. Install the development requirements by running "pip install -r requirements.txt"
4. Take a look at the [Project Structure](#Project-Structure) section below, and start writing your code!

Additionally, you can:

1. Set a pre-push Git hook to check your code before pushing it to your Github branch:
    - copy pre-push script to .git/hooks folder (cp pre-push .git/hooks) folder
    - give execute permissions to pre-push script (chmod u+x .git/hooks/pre-push)
    
    
## Project Structure

1. Source code location
2. Folder per individual lambda
3. Lambda handler
4. Dependencies file to manage internal and external dependencies
5. Common code

6. Tests structure
7. Folder per individual lambda
8. Hooks per individual lambda
9. Common code tests

10. Integration tests

11. Config files: prospector and pylint
12. Api Contract Specification
13. Sam api template
14. Setup cloudformation templates
15. Buildspec files: pr and staging

16. Developer tools: test, unit-tests, coverage

17. packager


## How to work on the project

1. git co master
2. git pull
3. git co -b new_branch
4. make changes
5. run checks with pre-push, or individually (swagger, cloudformation, bandit, prospector, unittest, coverage)
6. git push -u origin new_branch
7. keep making changes
8. when finished, raise a PR in github. This will trigger a build in your AWS account
9. If the build is green, get your code reviewed (and approved if ok) by another contributor
10. If approved, rebase and merge into master

## How to run the project locally

If you want to see if your lambdas work before uploading to AWS, run the following instructions from the buildspec-dev file:

1. ./packager
2. sam build -s .build -t api-template.yaml
...
    
## The Future

1. Nested stacks and SAM ?
2. Nested OpenApi ?


Note: set chmod u+x on pre-push and packager!!

Note: ensure you remove .build and .aws-build folders or bandit will take ages!!

Note: requirements.txt on lambda folders will be overriden. The same with src folders!

Note: Setup prod process

Note: Symlinks options


[build-status]: https://codebuild.eu-west-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiTnE5ck1FRWpyK25SVm1tMTdnT3RBUENsRzBLWDREYjJ0ZUZsTkNacVAxMFFhUmxDaWxkeE43MWU1cnlzNnNESGw3QzJTdzduU25vVUFNaDN3UEE5bzFBPSIsIml2UGFyYW1ldGVyU3BlYyI6InB2LzE2MGRLY3czVXpmdlQiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master
[mit-license-svg]: https://img.shields.io/badge/License-MIT-yellow.svg
[mit-license]: https://opensource.org/licenses/MIT
[release]: https://img.shields.io/github/release/gridsmartercities/python-serverless-template.svg?style=flat
[serverless-framework]: https://serverless.com/
[sam]: https://aws.amazon.com/serverless/sam/
[cloudformation]: https://aws.amazon.com/cloudformation/
[openapi-3]: https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md
[swagger-cli]: https://www.npmjs.com/package/swagger-cli
[unittest]: https://docs.python.org/3/library/unittest.html
[coverage]: https://coverage.readthedocs.io/en/v4.5.x/
[prospector]: https://coverage.readthedocs.io/en/v4.5.x/
[pylint-quotes]: https://github.com/edaniszewski/pylint-quotes
[pylint]: https://www.pylint.org/
[bandit]: https://bandit.readthedocs.io/en/latest/
[dredd]: https://github.com/apiaryio/dredd
[codebuild-badge]: https://codebuild.eu-west-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiTnE5ck1FRWpyK25SVm1tMTdnT3RBUENsRzBLWDREYjJ0ZUZsTkNacVAxMFFhUmxDaWxkeE43MWU1cnlzNnNESGw3QzJTdzduU25vVUFNaDN3UEE5bzFBPSIsIml2UGFyYW1ldGVyU3BlYyI6InB2LzE2MGRLY3czVXpmdlQiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master
[codebuild-cost]: https://aws.amazon.com/codebuild/pricing/