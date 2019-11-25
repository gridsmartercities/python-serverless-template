import unittest
from unittest.mock import patch
from src.a_lambda.a_lambda import handler


class ALambdaTests(unittest.TestCase):

    @patch("src.a_lambda.a_lambda.LOGGER")
    def test_success(self, mock_logger):
        response = handler(None, None)
        self.assertEqual(200, response["statusCode"])
        self.assertEqual("""{"message": "HELLO FROM A_LAMBDA"}""", response["body"])
        mock_logger.info.assert_called_once_with("Some info message")
