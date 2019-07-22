[<img align="right" alt="Grid Smarter Cities" src="https://s3.eu-west-2.amazonaws.com/open-source-resources/grid_smarter_cities_small.png">](https://www.gridsmartercities.com/)

![Build Status][build-status]
[![License: MIT][mit-license-svg]][mit-license]
![Github Release][release]

# python-serverless-template

This is a Github Template to generate Serverless APIs (and more) in Python using AWS SAM.
 
This template does not use the fantastic [Serverless Framework][serverless-framewor]. You might want to look at it too.

This template is opinionated, and makes use of:

- [AWS SAM][sam] for the AWS resourses specification.
- [AWS codebuild][codebuild] to setup CI/CD in your AWS account.
- [OpenApi 3][openapi-3] for defining the API contract.
- The [Swagger CLI][swagger-cli] to validate the OpenAPI specification.
- The Python [unittest][unittest] library for unit testing.
- [Coverage][coverage], to ensure the Python code is 100% unit tested
- [Prospector][prospector], a python tool to check code quality.
- [pylint_quotes][pylint-quotes], a [pylint][pylint] plugin to ensure a consistent Python quotation style throughout the project.
- [Bandit][bandit], a security testing tool.
- [Dredd][dredd], for contract testing against the OpenAPI definition, with hooks written in Python.
- A custom packaging tool to ease the sharing of code between [lambda functions][lambda].


## Project Set up

1. Create a Github repo by clicking on the Github template button above.
2. [Create an AWS account][aws-account-create] if you don't have one already.
3. Create an AWS S3 bucket:
    - In your AWS account, go to services and type s3.
    - In S3, click on the "Create bucket" button.
    - In the wizard, enter your-project-name-build-bucket in the "Name" input box.
    - Click Next until you complete the wizard.
4. Create a "dev" codebuild project in your account:    
    - In your AWS account, go to services and type codebuild.
    - Select the region you want to use from the top-right Region dropdown.
    - In codebuild, click on the "Create build project" button.
    - Enter your-project-name-dev as the "Project name".
    - In the "Source" section, select "GitHub" as the "Source Provider".
    - With "Connect using OAuth" selected, click on "Connect to GitHub". 
    - You should be taken to a GitHub authorization page. AWS codebuild might need access to your organization. If so, click on the "Grant" button to the side of your organization name. Finally, click on "Authorize aws-codesuite" (you might need to confirm your GitHub password).
    - On the "Primary source webhook events" section, select the "Rebuild every time a code change is pushed to this repository" option.
    - In the "Event type" section, select "PULL_REQUEST_CREATED", "PULL_REQUEST_UPDATED", and "PULL_REQUEST_REOPENED" options. We want the build to be triggered when a GitHub Pull Request is created, updated or reopened.
    - In the "Environment" section, select "Managed Image".
    - Select "Ubuntu" in the "Operating system" dropdown.
    - Select "standard" in the "Runtime(s)" dropdown.
    - Select "aws/codebuild/standard:1.0" in the "Image" dropdown and leave "Always use the latest image for this runtime version" selected in the "Image version" dropdown.
    - Ensure "New service role" is selected in the "Service role" option.
    - Enter codebuild-your-project-name-dev-service-role in the "Role name" input box.
    - In the "Buildspec" section, leave "Use a buildspec file" selected, and enter buildspec-dev.yaml in the "Buildpec name - optional" input box.
    - Finally, click on "Create build project" at the bottom of the page.
5. Update the "dev" webhook in Github, to trigger the AWS codebuild on Pull Requests only:
    - In your GitHub account, select "Settings".
    - Go to the "Webhooks" section. You should see a webhook created by AWS codebuild. Click on "Edit".
    - In the "Which events would you like to trigger this webhook?" select "Let me select individual events." and tick the "Pull requests" box only.
    - Click on "Update webhook" at the bottom.
6. Create a "stg" codebuild project in your account, as per point 4 above, and with the following changes:
    - Replace "dev" for "stg" everywhere.
    - In the "Event type" section select just "PUSH" as "Event type", and expand the "Start a build under this conditions" section. In the "HEAD_REF - optional" input, add ^refs/heads/master$. We want the build to be triggered by a push to the GitHub master branch only.
7. Update the "stg" webhook in Github, to trigger the AWS codebuild on Push to the master branch only. 
    - In your GitHub account, select "Settings".
    - Go to the "Webhooks" section. You should see a webhook created by AWS codebuild. Click on "Edit".
    - In the "Which events would you like to trigger this webhook?" select "Just the push event" option.
    - Click on "Update webhook" at the bottom.
8. (Optional) To stop contributors from committing code directly to the master branch, setup a master branch protection rule in GitHub. Only Peer reviewed, approved Pull Requests will be allowed to be merged into the master branch.
    - in your GitHub account, select "Settings".
    - Go to the "Branches" section, and click on "Add rule"
    - In the Branch name pattern, enter "master"
    - In the Rule settings:
        - select "Require pull request reviews before merging", and "Dismiss stale pull request approvals when new commits are pushed".
        - select "Require status checks to pass before merging", and "Require branches to be up to date before merging". After running your first build (when raising your first Pull Request), you should be able to make the codebuild run required in the "status checks" area of this section.
        - select "Include administrators".
        - click on the "Create" button.
9. (Optional) With this codebuild setup, it is likely codebuild will raise permissions issues when running the build. The correct option to manage this is to add the missing permissions to the AWS Policies associated to the codebuild roles you created when setting up the build projects. This can, however, be time consuming and you might want to give the dev and stg codebuild roles Administrator privileges. To do that:
    - In AWS, go to "Services" and type iam
    - In IAM, select "Roles"
    - Click on your dev role (codebuild-your-project-name-dev-service-role).
    - Click on "Attach policies", and select "AdministratorAccess".
    - Click on the "Attach policy" button.
    - Repeat for the stg role (codebuild-your-project-name-stg-service-role).
10. Codebuild will need to access your S3 bucket. It does so by having the bucket name added as a parameter in the buildspec files. To add the bucket name to the parameter store:
    - In AWS, go to "Services" and type systems manager.
    - Select "Parameter Store".
    - Click on the "Create parameter" button.
    - Enter "/your-project-name/build/SAM_S3_BUCKET" in the "Name" input.
    - Ensure "Standar" and "String" are selected in "Tier" and "Type".
    - Enter "your-project-name-build-bucket" in the "Value" textarea.
    
### A NOTE ON COSTS:

1. [Codebuild has a cost][codebuild-cost] of around $1 per 200 build minutes beyond the first 100 free-tier minutes.
2. You might need a GitHub Pro ($7 per month) account to setup branch protection rules.

## Developer Set up

To follow these instructions, you will need to be familiar with pip, and creating and managing Python virtual environments. If you are not, take a look at [this][pip-and-ve].

1. Clone your new repo locally.
    - Change "python-serverless-template" to "your-project-name" everywhere in the repo.
2. Create a Python virtual environment.
3. Install the development requirements by running "pip install -r requirements.txt".
4. Install the swagger cli by running "npm install swagger-cli"
5. Take a look at the [Project Structure](#Project-Structure) section below, and start writing your code.
6. (Optional) Set a pre-push Git hook to check your code before pushing it to your Github branch:
    - copy pre-push script to .git/hooks folder (cp pre-push .git/hooks) folder
    - give execute permissions to pre-push script (chmod u+x .git/hooks/pre-push)
    
### To run dredd locally:

1. Install dredd locally by running "npm install dredd"
2. After creating a Pull Request, go to your AWS codebuild project and take a look at the BASE_URL in the codebuild logs (you can also get it from ApiGateway)
3. Add the BASE_URL to your local environment variables by running "export BASE_URL=your-base-url-from-codebuild"
4. Run dredd by typing "dredd api-contract.yaml $BASE_URL --hookfiles=tests/hooks.py --hookfiles=tests/*/hooks.py --language python"
    
    
## Project Structure

### Code

The source code is located in the src folder. All code common to more than 1 lambda should be placed in files in that directory (or subfolders in that directory) following the Single Responsibility and Interface Segregation principles.

Each lambda has its own folder inside src, which contains the lambda code itself and a dependencies (either yaml or json) file that indicates the internal (common code) and external dependencies (packages) the lambda needs.

### Tests

Unit and contract tests are inside the tests folder, and follows the same structure as the code. Unit tests are placed in files starting with "test_", and contract tests are written as [Dredd hooks][dredd-hooks].

Integration tests are separated into their own it folder.

### Config Files

The .prospector.yaml and the .pylintrc files allows you to change the way prospector runs. Other than forcing 120 characters per line, and the use of double quotes instead of single quotes (using the [pylint_quotes][pylint-quotes] plugin), the config files have the out of the box configuration for those tools. 

### Buildspec Files

Two buildspec files are included, one for the "dev" build and the other for the "stg" (Staging) build. A production build could also be generated from the "stg" buildspec, and could be triggered by, say, if the integration tests have successfully run on the staging build.

### API Contract Specification

You can define your API contract in api-contract.yaml, as per the [OpenApi 3.0 specification][openapi-3].

### SAM template

You can define your AWS resources in api-template.yaml, as per AWS's Serverless Application Model ([SAM][sam]).

### Developer tools

Four small scripts have been added to ease the development process:

- Run all unit tests ([unit-tests][tool-unit-tests])
- Run individual unit tests ([test][tool-test])
- Run test coverage ([coverage][tool-coverage])
- Run swagger validation, cloudformation template validate, bandit, prospector, unittest and coverage in one command ([pre-push][tool-pre-push])

### Packager

This is a custom tool that manages lambda dependencies so only the right common code and external dependencies are packaged with each lambda. The tool is used by the build process, but you can also run it [locally](#How-to-run-the-project-locally).

The tool can work with json or yaml files. For each lambda, add a "dependencies.yaml" or "dependencies.json" in the lambda folder. In there, add all internal code dependencies in the "internal" array, and all the external packages needed by your lambda in the "external" array.

The packager creates a .build folder when run, that contains a copy of the internal common files needed by that lambda, and a requirements.txt files with a list of all the external dependencies.

Please note that if you run this packager locally, the .build folder might make the Bandit tests to take quite a lot of time. You might want to delete the .build folder once you've taken a look at it.

## How to work on the project

1. git checkout master
2. git pull
3. git checkout -b your_new_feature_branch_name
4. make your feature changes
5. run checks with pre-push, or run them individually (swagger, cloudformation, bandit, prospector, unittest, coverage). You can find the commands in the buildspec-dev.yaml file, and in the pre-push script.
6. git push -u origin your_new_feature_branch_name (it will trigger an automatic pre-push check if you have configured the optional point 5 of the developer set up process).
7. when finished, raise a PR in GitHub. This will trigger a build in your AWS account
8. If the build is green, get your code reviewed (and approved if ok) by another contributor
9. If approved, rebase and merge into master
10. To work on a new feature, repeat 1-9.

## How to add a new API Gateway endpoint backed by a lambda function

You can add a new endpoint (or a method to an endpoint) in the api-contract.yaml. 

You can define your AWS Function resource (and any other resources needed: database, roles, policies, ...) in the api-template.yaml SAM template.

Create a folder with the same name in the tests folder, and add a python file with a test_ name to it. Start writing your unit tests there. Add a hooks.py file too if this lambda function needs to be contract tested (and you need to specify special hooks for dredd).

Create a new folder with the name of your feature inside the src folder, and add a python file with an adecuate name to it. In this python file, define your lambda function handler.

If you add a dependency (to an internal file with common code, or to an external python package), add a dependencies.json or dependencies.yaml file to your lambda folder, and specify the dependencies there.
    
## Future work

Adding cloudformation templates to setup the codebuild projects.


[build-status]: https://codebuild.eu-west-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiTnE5ck1FRWpyK25SVm1tMTdnT3RBUENsRzBLWDREYjJ0ZUZsTkNacVAxMFFhUmxDaWxkeE43MWU1cnlzNnNESGw3QzJTdzduU25vVUFNaDN3UEE5bzFBPSIsIml2UGFyYW1ldGVyU3BlYyI6InB2LzE2MGRLY3czVXpmdlQiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master
[mit-license-svg]: https://img.shields.io/badge/License-MIT-yellow.svg
[mit-license]: https://opensource.org/licenses/MIT
[release]: https://img.shields.io/github/release/gridsmartercities/python-serverless-template.svg?style=flat
[serverless-framework]: https://serverless.com/
[sam]: https://aws.amazon.com/serverless/sam/
[codebuild]: https://aws.amazon.com/codebuild/
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
[aws-account-create]: https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/
[lambda]: https://docs.aws.amazon.com/lambda/latest/dg/welcome.html
[dredd-hooks]: https://dredd.org/en/latest/hooks/js.html
[pip-and-ve]: https://packaging.python.org/guides/installing-using-pip-and-virtual-environments/
[tool-unit-tests]: https://github.com/gridsmartercities/python-serverless-template/unit-tests
[tool-test]: https://github.com/gridsmartercities/python-serverless-template/test
[tool-coverage]: https://github.com/gridsmartercities/python-serverless-template/coverage
[tool-pre-push]: https://github.com/gridsmartercities/python-serverless-template/pre-push