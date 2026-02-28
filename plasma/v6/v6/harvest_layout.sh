#!/bin/bash

# 1. Define paths
MASTER_FILE="$HOME/dotfiles/plasma/v6/appletsrc.master"
CURRENT_CONFIG="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"

# 2. Check if the config exists before trying to copy
if [ -f "$CURRENT_CONFIG" ]; then
    # Create the header with a timestamp
    echo "# Captured from $(hostname) on $(date)" > "$MASTER_FILE"
    
    # Use 'cat' to append the contents into the master file
    cat "$CURRENT_CONFIG" >> "$MASTER_FILE"
    
    echo "✅ Success: Current layout harvested to $MASTER_FILE"
else
    echo "❌ Error: Could not find $CURRENT_CONFIG"
    exit 1
fi
