#!/bin/bash

# Exit on error
set -e

echo "Setting up Python development environment with uv on macOS..."

# 1. Check for Homebrew
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Please install Homebrew first."
    echo "See https://brew.sh/"
    exit 1
fi

# 2. Install Python if not present
if ! command -v python3 &> /dev/null; then
    echo "Installing Python 3..."
    brew install python
fi

# 3. Install pipx
if ! command -v pipx &> /dev/null; then
    echo "Installing pipx..."
    brew install pipx
fi

# Ensure .local/bin is in the PATH for this script's session, for pipx and tools installed by it
export PATH="$HOME/.local/bin:$PATH"

# 4. Install uv with pipx
if ! command -v uv &> /dev/null; then
    echo "Installing uv with pipx..."
    pipx install uv
fi

# 5. Check for pyproject.toml
if [ ! -f "pyproject.toml" ]; then
    echo "Error: pyproject.toml not found!"
    echo "Please create a pyproject.toml file before continuing."
    echo "This file should define your project's metadata and dependencies."
    exit 1
fi

# 6. Create a virtual environment with uv
echo "Creating virtual environment..."
uv venv

# 7. Install dependencies
echo "Installing dependencies..."
uv lock
uv pip sync uv.lock

# 8. Provide activation instructions
echo "Setup complete!"
echo "To activate the virtual environment, run:"
echo "source .venv/bin/activate"
