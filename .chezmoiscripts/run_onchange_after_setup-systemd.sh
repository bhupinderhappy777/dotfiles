#!/bin/bash
# Enable and start systemd user services

set -euo pipefail

# Skip in CLI environments (Codespaces, SSH without X11, etc.)
if [[ -n "${CODESPACES:-}" ]] || [[ -z "${DISPLAY:-}" ]]; then
    echo "Skipping systemd user services setup in CLI environment"
    exit 0
fi

echo "Setting up systemd user services..."

# Reload systemd user daemon
systemctl --user daemon-reload

# Enable and start inbox watcher
if systemctl --user is-enabled inbox-watcher.service &>/dev/null; then
    echo "inbox-watcher.service already enabled"
else
    echo "Enabling inbox-watcher.service..."
    systemctl --user enable inbox-watcher.service
fi

if systemctl --user is-active inbox-watcher.service &>/dev/null; then
    echo "inbox-watcher.service already running"
else
    echo "Starting inbox-watcher.service..."
    systemctl --user start inbox-watcher.service
fi

# Enable and start wallpaper refresh timer
if systemctl --user is-enabled wallpaper-refresh.timer &>/dev/null; then
    echo "wallpaper-refresh.timer already enabled"
else
    echo "Enabling wallpaper-refresh.timer..."
    systemctl --user enable wallpaper-refresh.timer
fi

if systemctl --user is-active wallpaper-refresh.timer &>/dev/null; then
    echo "wallpaper-refresh.timer already running"
else
    echo "Starting wallpaper-refresh.timer..."
    systemctl --user start wallpaper-refresh.timer
fi

# Enable and start Plasma auto-harvest path watcher
if systemctl --user is-enabled plasma-harvest.path &>/dev/null; then
    echo "plasma-harvest.path already enabled"
else
    echo "Enabling plasma-harvest.path..."
    systemctl --user enable plasma-harvest.path
fi

if systemctl --user is-active plasma-harvest.path &>/dev/null; then
    echo "plasma-harvest.path already running"
else
    echo "Starting plasma-harvest.path..."
    systemctl --user start plasma-harvest.path
fi

echo "Systemd services configured!"
