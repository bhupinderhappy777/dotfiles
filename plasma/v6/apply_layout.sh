#!/bin/bash
export XDG_RUNTIME_DIR=/run/user/$(id -u)

# 1. Detect Activity (Universal method)
CURRENT_ACT=$(dbus-send --session --print-reply --dest=org.kde.ActivityManager /ActivityManager/Activities org.kde.ActivityManager.Activities.CurrentActivity | grep string | cut -d '"' -f 2 | tr -d '[:space:]')

# 2. Kill services properly
systemctl --user stop plasma-plasmashell.service xdg-desktop-portal.service
killall -9 plasmashell xdg-desktop-portal-kde 2>/dev/null
sleep 2

# 3. Apply patched config
sed "s/activityId=[a-fA-F0-9\-]*/activityId=$CURRENT_ACT/g" "$HOME/dotfiles/plasma/v6/appletsrc.master" > "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"

# 4. Deep cache wipe (Prevents the SIGABRT)
rm -rf ~/.cache/plasmashell
rm -rf ~/.cache/plasma*
rm -f ~/.cache/*.kcache
kbuildsycoca6 --noincremental

# 5. Start
systemctl --user start xdg-desktop-portal.service
sleep 2
systemctl --user start plasma-plasmashell.service
