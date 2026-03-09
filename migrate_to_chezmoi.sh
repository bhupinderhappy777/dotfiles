#!/bin/bash
# Script to migrate dotfiles structure from stow to chezmoi format

set -euo pipefail

cd ~/dotfiles

echo "Migrating to chezmoi structure..."

# Create base directories
mkdir -p dot_config/systemd/user
mkdir -p dot_config/audacity
mkdir -p dot_config/doublecmd
mkdir -p dot_local/share/konsole
mkdir -p dot_var/app/com.visualstudio.code/config/Code/User

# Move git config
if [[ -f git/.gitconfig ]]; then
    mv git/.gitconfig dot_gitconfig
    echo "✓ Moved git/.gitconfig → dot_gitconfig"
fi

# Move zsh config
if [[ -f zsh/.zshrc ]]; then
    mv zsh/.zshrc dot_zshrc
    echo "✓ Moved zsh/.zshrc → dot_zshrc"
fi

# Move starship config
if [[ -f zsh/.config/starship.toml ]]; then
    mv zsh/.config/starship.toml dot_config/starship.toml
    echo "✓ Moved zsh/.config/starship.toml → dot_config/starship.toml"
fi

# Move plasma common configs
if [[ -d plasma/common/.config ]]; then
    for file in plasma/common/.config/*; do
        if [[ -f "$file" ]]; then
            filename=$(basename "$file")
            mv "$file" "dot_config/$filename"
            echo "✓ Moved $file → dot_config/$filename"
        fi
    done
fi

# Move systemd units
if [[ -d systemd/.config/systemd/user ]]; then
    for file in systemd/.config/systemd/user/*; do
        if [[ -f "$file" ]]; then
            filename=$(basename "$file")
            mv "$file" "dot_config/systemd/user/$filename"
            echo "✓ Moved $file → dot_config/systemd/user/$filename"
        fi
    done
fi

# Move audacity config
if [[ -f audacity/.config/audacity/audacity.cfg ]]; then
    mv audacity/.config/audacity/audacity.cfg dot_config/audacity/audacity.cfg
    echo "✓ Moved audacity/.config/audacity/audacity.cfg → dot_config/audacity/audacity.cfg"
fi

# Move doublecmd configs
if [[ -d doublecmd/.config/doublecmd ]]; then
    for file in doublecmd/.config/doublecmd/*; do
        if [[ -f "$file" ]]; then
            filename=$(basename "$file")
            mv "$file" "dot_config/doublecmd/$filename"
            echo "✓ Moved $file → dot_config/doublecmd/$filename"
        fi
    done
fi

# Move konsole profile
if [[ -f konsole/.local/share/konsole/my_profile.profile ]]; then
    mv konsole/.local/share/konsole/my_profile.profile dot_local/share/konsole/my_profile.profile
    echo "✓ Moved konsole/.local/share/konsole/my_profile.profile → dot_local/share/konsole/my_profile.profile"
fi

# Move vscode configs
if [[ -d vscode/.var/app/com.visualstudio.code/config/Code/User ]]; then
    for file in vscode/.var/app/com.visualstudio.code/config/Code/User/*; do
        if [[ -f "$file" ]]; then
            filename=$(basename "$file")
            mv "$file" "dot_var/app/com.visualstudio.code/config/Code/User/$filename"
            echo "✓ Moved $file → dot_var/app/com.visualstudio.code/config/Code/User/$filename"
        fi
    done
fi

# Clean up empty directories
rm -rf git/
rm -rf zsh/.config/
rm -rf plasma/common/.config/
rm -rf systemd/.config/
rm -rf audacity/.config/
rm -rf doublecmd/.config/
rm -rf konsole/.local/
rm -rf vscode/.var/

echo ""
echo "Migration complete! Old module directories have been cleaned up."
echo "Run 'chezmoi add --autotemplate' to finalize the migration."
