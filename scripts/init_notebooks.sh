#!/bin/bash

# Script to set up VS Code/Cursor with Nix Python environment

set -e

echo "Setting up VS Code/Cursor for Nix Python environment..."

# Get the Python path from Nix environment
PYTHON_PATH=$(nix develop ./nix --command which python)
echo "Found Python at: $PYTHON_PATH"

# Create .vscode directory if it doesn't exist
mkdir -p .vscode

# Create or update VS Code settings
cat > .vscode/settings.json << EOF
{
    "python.defaultInterpreterPath": "$PYTHON_PATH",
    "jupyter.kernels.filter": [
        {
            "path": "/Users/mick/Library/Jupyter/kernels/nix-python",
            "type": "pythonEnvironment"
        }
    ],
    "notebook.defaultKernel": "nix-python"
}
EOF

echo "VS Code settings updated!"
echo "Python interpreter set to: $PYTHON_PATH"
echo ""
echo "Now you can:"
echo "1. Reload VS Code/Cursor window (Cmd+Shift+P -> 'Developer: Reload Window')"
echo "2. Open your notebook and select 'Python (Nix)' kernel when prompted" 