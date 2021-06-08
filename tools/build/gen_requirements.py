import os
import yaml


REQ_PATH = "requirements.txt"
TEMPLATE = "template.yaml"
SOURCE_PATH = ".build"


def run() -> None:
    # escape any function in the yaml (!Sub etc.) - not needed to get function code uris
    yaml.add_multi_constructor("!", lambda loader, suffix, node: None)  # type: ignore

    with open(TEMPLATE, "r") as template_file:
        # unsafe load should be safe here as we're escaping any potential issue
        template = yaml.unsafe_load(template_file)
        resources = template.get("Resources", {})
        lambdas = [resources[res] for res in resources if resources[res].get("Type") == "AWS::Serverless::Function"]
        for function in lambdas:
            code_uri = function["Properties"]["CodeUri"]
            lambda_directory = os.path.join(SOURCE_PATH, code_uri)
            print(lambda_directory)
            req_path = os.path.join(lambda_directory, REQ_PATH)
            with open(req_path, "a") as _:
                # open the requirements file with mode 'append'
                # create the file if it doesn't exist and leave it unedited if it does
                pass


if __name__ == "__main__":
    run()
