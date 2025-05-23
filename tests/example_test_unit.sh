#!/bin/bash

# Activate the virtual environment
source .venv/bin/activate

# Apply environment variables
source env/env.env

# Run the test with pytest's built-in features:
# -v: verbose output
# --tb=short: shorter traceback format
python -m pytest tests/example_test_unit.py::test_example_function_operation -v --tb=short

# Deactivate virtual environment if it was activated
if [ -n "$VIRTUAL_ENV" ]; then
    deactivate
fi
