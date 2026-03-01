#!/bin/bash

# 1. Environment Setup
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

# Detect Plasma Version
if command -v kwriteconfig6 >/dev/null 2>&1; then
    KWC="kwriteconfig6"
    PLASMA_V=6
else
    KWC="kwriteconfig5"
    PLASMA_V=5
fi

# 2. Configuration
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
SAVE_DIR="$HOME/Pictures/Wallpapers"
SAVE_PATH="$SAVE_DIR/wallhaven_$TIMESTAMP.jpg"
mkdir -p "$SAVE_DIR"

# Cleanup old wallpapers
rm -f $SAVE_DIR/wallhaven_*.jpg

# 3. Fetch from Wallhaven API (4K Abstract)
echo "🔍 Searching Wallhaven for 4K Abstract..."
IMG_URL=$(curl -s "https://wallhaven.cc/api/v1/search?q=id:37&categories=100&atleast=3840x2160&colors=000000&sorting=random" | jq -r '.data[0].path')

if [ "$IMG_URL" != "null" ] && [ -n "$IMG_URL" ]; then
    curl -L "$IMG_URL" -o "$SAVE_PATH"

    # 4. Apply to Desktop via D-Bus
    # Works for both v5 and v6 to trigger immediate UI refresh
    dbus-send --session --dest=org.kde.plasmashell --type=method_call /PlasmaShell org.kde.PlasmaShell.evaluateScript "string:
        var Desktops = desktops();
        for (i=0; i<Desktops.length; i++) {
            d = Desktops[i];
            d.wallpaperPlugin = 'org.kde.image';
            d.currentConfigGroup = Array('Wallpaper', 'org.kde.image', 'General');
            d.writeConfig('Image', 'file://$SAVE_PATH');
        }
    "

    # 5. Apply to Lock Screen (The "Pro" Touch)
    # Using the detected kwriteconfig version for the specific OS
    $KWC --file kscreenlockerrc --group "Greeter" --group "Wallpaper" --group "org.kde.image" --group "General" --key "Image" "file://$SAVE_PATH"

    # 6. Restore Shortcuts (Fixes the KDE bug where shortcuts die after wallpaper change)
    killall kglobalaccel 2>/dev/null
    # Search for the binary in common locations across Fedora and Ubuntu
    PATHS=("/usr/bin/kglobalaccel" "/usr/lib/x86_64-linux-gnu/libexec/kglobalaccel" "/usr/libexec/kglobalaccel")
    for p in "${PATHS[@]}"; do
        if [ -f "$p" ]; then
            "$p" &
            break
        fi
    done

    echo "✅ Success! Desktop and Lock Screen updated to: wallhaven_$TIMESTAMP.jpg"
else
    echo "❌ Wallhaven API error."
    exit 1
fi
