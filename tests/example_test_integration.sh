#!/bin/bash

# Activate the virtual environment
source .venv/bin/activate

# Apply environment variables
source env/env.env

# Run the test with pytest's built-in features:
# -v: verbose output
# -s: show print statements
# --capture=no: show all output
# --tb=short: shorter traceback format
python -m pytest tests/example_test_integration.py::test_example_integration -v -s --capture=no --tb=short

# Deactivate virtual environment if it was activated
if [ -n "$VIRTUAL_ENV" ]; then
    deactivate
fi
