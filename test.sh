#!/bin/bash

coverage run --branch --source='.' -m unittest tests/test_*.py
coverage run --branch --source='.' -m unittest tests/*/test_*.py