#!/bin/bash

set -euo pipefail

# 1. Define paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MASTER_FILE="${SCRIPT_DIR}/appletsrc.master"
LOCKSCREEN_MASTER_FILE="${SCRIPT_DIR}/kscreenlockerrc.master"
CURRENT_CONFIG="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
CURRENT_LOCKSCREEN_CONFIG="$HOME/.config/kscreenlockerrc"

write_if_changed() {
    local source_file="$1"
    local target_file="$2"
    local label="$3"

    local tmp_file
    tmp_file="$(mktemp)"
    cp "$source_file" "$tmp_file"

    if [[ -f "$target_file" ]] && cmp -s "$tmp_file" "$target_file"; then
        rm -f "$tmp_file"
        echo "No change: ${label} unchanged"
        return 0
    fi

    mv "$tmp_file" "$target_file"
    echo "✅ Updated: ${label} harvested to $target_file"
}

# 2. Check if the config exists before trying to copy
if [ -f "$CURRENT_CONFIG" ]; then
    write_if_changed "$CURRENT_CONFIG" "$MASTER_FILE" "Current layout"
else
    echo "❌ Error: Could not find $CURRENT_CONFIG"
    exit 1
fi

# 3. Harvest lock screen config
if [ -f "$CURRENT_LOCKSCREEN_CONFIG" ]; then
    write_if_changed "$CURRENT_LOCKSCREEN_CONFIG" "$LOCKSCREEN_MASTER_FILE" "Lock screen config"
else
    echo "⚠️ Warning: Could not find $CURRENT_LOCKSCREEN_CONFIG (skipped)"
fi
