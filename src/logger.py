import logging
from logging import Logger
import os


LOG_LEVEL = getattr(logging, os.getenv("LOG_LEVEL", "INFO"))


def get_logger(name: str) -> Logger:
    logger = logging.getLogger(name)
    logger.setLevel(LOG_LEVEL)
    return logger
