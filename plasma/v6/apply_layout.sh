#!/bin/bash
export DISPLAY=:0
export XDG_RUNTIME_DIR=/run/user/$(id -u)

# 1. Get the REAL Activity ID of your current session
# This ensures the desktop "Containment" actually connects to your screen
CURRENT_ACT=$(dbus-send --session --print-reply --dest=org.kde.ActivityManager /ActivityManager/Activities org.kde.ActivityManager.Activities.CurrentActivity | grep string | cut -d '"' -f 2)

# 2. Stop the shell safely
systemctl --user stop plasma-plasmashell.service
killall -9 plasmashell 2>/dev/null
sleep 3

# 3. Copy the master file and IMMEDIATELY patch the ID
cp "$HOME/dotfiles/plasma/v6/appletsrc.master" "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
sed -i "s/activityId=[a-z0-9-]*/activityId=$CURRENT_ACT/g" "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"

# 4. Wipe caches and restart
rm -rf ~/.cache/plasmashell
systemctl --user start plasma-plasmashell.service
