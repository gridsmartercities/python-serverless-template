from src.common import hello_func
from aws_lambda_decorators import cors


@cors()
def lambda_handler(event, context):  # pylint:disable=unused-argument
    return {
        "statusCode": 200,
        "body": hello_func("a_lambda")
    }
