#!/bin/bash

# 1. Kill the current shell to avoid conflicts during the update
kquitapp6 plasmashell || killall plasmashell
sleep 2

# 2. Tell Plasma to execute your JS blueprint
dbus-send --dest=org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "string:$(cat ~/dotfiles/plasma/layout.js)"

# 3. Restart the shell
kstart6 plasmashell &
