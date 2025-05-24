#!/bin/bash

# Ensure we're in the Nix development environment
nix develop --extra-experimental-features nix-command

# Apply environment variables if the file exists
if [ -f "env/env.env" ]; then
    source env/env.env
fi

# Run the test with pytest's built-in features:
# -v: verbose output
# --tb=short: shorter traceback format
python -m pytest tests/example_test_unit.py::test_example_function_operation -v --tb=short
