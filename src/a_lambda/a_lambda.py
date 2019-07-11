from aws_lambda_decorators import cors, log
from src.common import hello_func


@cors()
@log(parameters=True, response=True)
def lambda_handler(event, context):  # pylint:disable=unused-argument
    return {
        "statusCode": 200,
        "body": hello_func("a_lambda")
    }
