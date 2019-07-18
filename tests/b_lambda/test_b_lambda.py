import unittest
from src.b_lambda.b_lambda import handler


class BLambdaTests(unittest.TestCase):

    def test_success(self):
        response = handler(None, None)
        self.assertEqual(200, response["statusCode"])
        self.assertEqual("""{"message": "HELLO FROM B_LAMBDA"}""", response["body"])
