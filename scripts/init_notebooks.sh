#!/bin/bash

# Comprehensive script to set up Nix + Jupyter notebooks environment from scratch
# This script can be used to initialize a new project or reset an existing one

set -e

echo "🚀 Initializing Nix + Jupyter notebooks environment..."
echo ""

# Step 1: Create nix directory and configuration files
echo "📁 Step 1: Creating Nix configuration files..."
mkdir -p nix

# Create flake.nix
cat > nix/flake.nix << 'EOF'
{
  description = "Python project development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = import ./shell.nix { inherit pkgs; };
      }
    );
} 
EOF

# Create shell.nix with Jupyter support
cat > nix/shell.nix << 'EOF'
{ pkgs ? import <nixpkgs> {} }:

let
  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    # Jupyter
    jupyter
    jupyterlab
    ipykernel
    
    # Testing
    pytest
    pytest-cov
    pytest-mock
    
    # Development tools
    black
    mypy
    ruff
    python-dotenv
  ]);
in

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Python environment
    pythonEnv
    
    # Development tools
    black
    mypy
    ruff
    
    # Git
    git
  ];

  shellHook = ''
    # Set up Python path
    export PYTHONPATH=$PWD/src:$PYTHONPATH
  '';
} 
EOF

echo "✅ Created nix/flake.nix and nix/shell.nix"

# Step 2: Create notebooks directory
echo ""
echo "📓 Step 2: Creating notebooks directory..."
mkdir -p src/notebooks

# Create a sample notebook if it doesn't exist
if [ ! -f "src/notebooks/notebook.ipynb" ]; then
    cat > src/notebooks/notebook.ipynb << 'EOF'
{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Welcome to your Nix-powered Jupyter notebook!\n",
    "print(\"Hello from Nix Python environment!\")\n",
    "\n",
    "# Check Python version and packages\n",
    "import sys\n",
    "print(f\"Python version: {sys.version}\")\n",
    "print(f\"Python executable: {sys.executable}\")"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python (Nix)",
   "language": "python",
   "name": "nix-python"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.12.10"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 2
}
EOF
    echo "✅ Created sample notebook: src/notebooks/notebook.ipynb"
else
    echo "✅ Notebooks directory exists"
fi

# Step 3: Initialize Nix environment and install Jupyter kernel
echo ""
echo "🔧 Step 3: Setting up Nix environment and Jupyter kernel..."

# Build the environment first
echo "Building Nix environment (this may take a few minutes on first run)..."
nix develop ./nix --command echo "Nix environment ready!"

# Get the Python path from Nix environment
PYTHON_PATH=$(nix develop ./nix --command which python)
echo "✅ Found Python at: $PYTHON_PATH"

# Install Jupyter kernel for the Nix environment
echo "Installing Jupyter kernel..."
nix develop ./nix --command python -m ipykernel install --user --name nix-python --display-name "Python (Nix)"
echo "✅ Installed 'Python (Nix)' kernel"

# Step 4: Configure VS Code/Cursor
echo ""
echo "⚙️  Step 4: Configuring VS Code/Cursor..."

# Create .vscode directory if it doesn't exist
mkdir -p .vscode

# Create or update VS Code settings
cat > .vscode/settings.json << EOF
{
    "python.defaultInterpreterPath": "$PYTHON_PATH",
    "notebook.defaultKernel": "nix-python",
    "jupyter.kernels.excludePythonEnvironments": [
        "/Users/$(whoami)/Library/Jupyter/kernels/nix-python"
    ]
}
EOF

echo "✅ VS Code settings updated!"

# Step 5: Create project structure if needed
echo ""
echo "📂 Step 5: Ensuring project structure..."
mkdir -p src/{config,functions,nodes}
mkdir -p tests/fixtures
mkdir -p scripts
mkdir -p services

echo "✅ Project structure created"

# Step 6: Create .gitignore if it doesn't exist
if [ ! -f ".gitignore" ]; then
    echo ""
    echo "📝 Step 6: Creating .gitignore..."
    cat > .gitignore << 'EOF'
# Nix
result
result-*
.direnv/

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Jupyter
.ipynb_checkpoints/
*/.ipynb_checkpoints/*

# VS Code
.vscode/launch.json
.vscode/tasks.json

# Environment
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# Secrets
secrets/
*.key
*.pem
EOF
    echo "✅ Created .gitignore"
fi

# Final instructions
echo ""
echo "🎉 Setup complete! Here's what you can do now:"
echo ""
echo "1. 📖 Start Jupyter Lab:"
echo "   nix develop ./nix --command jupyter lab"
echo ""
echo "2. 📝 Or start Jupyter Notebook:"
echo "   nix develop ./nix --command jupyter notebook"
echo ""
echo "3. 💻 For VS Code/Cursor:"
echo "   - Reload window: Cmd+Shift+P → 'Developer: Reload Window'"
echo "   - Open src/notebooks/notebook.ipynb"
echo "   - Select 'Python (Nix)' kernel when prompted"
echo ""
echo "4. 🔄 To enter Nix shell for development:"
echo "   nix develop ./nix"
echo ""
echo "5. 🔧 If you update Nix config, re-run this script:"
echo "   ./scripts/init_notebooks.sh"
echo ""
echo "📍 Python interpreter: $PYTHON_PATH"
echo "📍 Jupyter kernel: Python (Nix)"
echo ""
echo "Happy coding! 🚀" 