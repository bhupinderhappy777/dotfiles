#!/bin/bash
# GitHub Codespaces dotfiles auto-setup script
# This script installs chezmoi and applies the dotfiles configuration

set -e

SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)"

# Check if chezmoi is already installed
if ! command -v chezmoi &> /dev/null; then
    echo "Installing chezmoi..."
    sh -c "$(curl -fsLS get.chezmoi.io)"
else
    echo "chezmoi is already installed"
fi

# Initialize and apply dotfiles
echo "Applying dotfiles with chezmoi..."
chezmoi init --apply --source="${SOURCE_DIR}"

echo "Dotfiles setup complete!"
