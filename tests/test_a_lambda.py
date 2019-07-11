import unittest
from src.a_lambda.a_lambda import lambda_handler


class ALambdaTests(unittest.TestCase):

    def test_success(self):
        response = lambda_handler(None, None)
        self.assertEqual(200, response["statusCode"])
        self.assertEqual("HELLO FROM A_LAMBDA", response["body"])
