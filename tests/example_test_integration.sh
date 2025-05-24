#!/bin/bash

# Ensure we're in the Nix development environment
nix develop --extra-experimental-features nix-command

# Apply environment variables if the file exists
if [ -f "env/env.env" ]; then
    source env/env.env
fi

# Run the test with pytest's built-in features:
# -v: verbose output
# -s: show print statements
# --capture=no: show all output
# --tb=short: shorter traceback format
python -m pytest tests/example_test_integration.py::test_example_integration -v -s --capture=no --tb=short
