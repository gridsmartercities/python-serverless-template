import unittest
from src.b_lambda.b_lambda import lambda_handler


class BLambdaTests(unittest.TestCase):

    def test_success(self):
        response = lambda_handler(None, None)
        self.assertEqual(200, response["statusCode"])
        self.assertEqual("HELLO FROM B_LAMBDA", response["body"])
