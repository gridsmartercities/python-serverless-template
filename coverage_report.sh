#!/bin/bash

coverage run --branch --source='.' -m unittest tests/test_*.py
coverage run --branch --source='.' -m unittest tests/*/test_*.py
coverage report -m --fail-under=100 --omit=tests/*,it/*