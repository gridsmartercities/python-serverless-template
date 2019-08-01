import unittest
from src.a_lambda.a_lambda import handler


class IntegrationTests(unittest.TestCase):

    def test_success(self):
        # ...

        response = handler(None, None)
        self.assertEqual(200, response["statusCode"])
        self.assertEqual("""{"message": "HELLO FROM A_LAMBDA22"}""", response["body"])

        # ...

    def test_success2(self):
        # ...

        response = handler(None, None)
        self.assertEqual(200, response["statusCode"])
        self.assertEqual("""{"message": "HELLO FROM A_LAMBDA"}""", response["body"])

        # ...
