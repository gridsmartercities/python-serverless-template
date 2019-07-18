import json
from src.common import hello_func


def handler(event, context):  # pylint:disable=unused-argument
    return {
        "statusCode": 200,
        "body": json.dumps(hello_func("b_lambda"))
    }
