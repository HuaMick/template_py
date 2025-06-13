#!/bin/bash

# This script is used to initialize the macOS development environment.
# It sets up Nix, creates necessary directories, and creates shell.nix and flake.nix files.
# To test nix run: nix-shell nix/shell.nix

# Exit on error
set -e

echo "Setting up macOS development environment..."

# Check if homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Nix if not already installed
if ! command -v nix &> /dev/null; then
    echo "Installing Nix..."
    sh <(curl -L https://nixos.org/nix/install)
    # Source nix environment
    . ~/.nix-profile/etc/profile.d/nix.sh
fi

# Check if Nix Flakes are enabled
if ! grep -q "experimental-features = nix-command flakes" ~/.config/nix/nix.conf 2>/dev/null; then
    echo "Enabling Nix Flakes..."
    mkdir -p ~/.config/nix
    echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
fi

# Create necessary directories if they don't exist
mkdir -p tests
mkdir -p nix

# Create shell.nix if it doesn't exist
if [ ! -f "nix/shell.nix" ]; then
    echo "Creating shell.nix..."
    cat > nix/shell.nix << 'EOF'
{ pkgs ? import <nixpkgs> {} }:

let
  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    # Testing
    pytest
    pytest-cov
    pytest-mock
    
    # Development tools
    black
    mypy
    ruff
    
    # Google Cloud dependencies
    google-api-core
    google-auth
    google-cloud-core
    google-cloud-bigquery
    
    # Data processing
    numpy
    pandas
    
    # Other utilities
    pyyaml
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
    
    # Show welcome message
    echo "Development environment initialized!"
    echo "Python packages include pytest, black, mypy, ruff, google-cloud-bigquery"
  '';
}
EOF
fi

# Create flake.nix if it doesn't exist
if [ ! -f "nix/flake.nix" ]; then
    echo "Creating flake.nix..."
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
fi