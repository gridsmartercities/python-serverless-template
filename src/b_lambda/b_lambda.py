import json
from src.common import hello_func


# pylint:disable=unused-argument
def handler(event: dict, context: dict) -> dict:
    return {
        "statusCode": 200,
        "body": json.dumps(hello_func("b_lambda"))
    }
