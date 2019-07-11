from .common import hello_func


def lambda_handler(event, context):  # pylint:disable=unused-argument
    return {
        "statusCode": 200,
        "body": hello_func("a_lambda")
    }
