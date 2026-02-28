#!/bin/bash

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

# 1. Configuration
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
SAVE_DIR="$HOME/Pictures/Wallpapers"
SAVE_PATH="$SAVE_DIR/wallhaven_$TIMESTAMP.jpg"

mkdir -p "$SAVE_DIR"

# 2. Cleanup: Delete old wallpapers to save space
rm -f $SAVE_DIR/wallhaven_*.jpg

# 3. Fetch from Wallhaven API
echo "🔍 Searching Wallhaven for 4K Abstract..."
IMG_URL=$(curl -s "https://wallhaven.cc/api/v1/search?q=id:37&categories=100&atleast=3840x2160&colors=000000&sorting=random" | jq -r '.data[0].path')

if [ "$IMG_URL" != "null" ] && [ -n "$IMG_URL" ]; then
    curl -L "$IMG_URL" -o "$SAVE_PATH"

    # 4. Apply via D-Bus (Plasma 5 standard)
    dbus-send --session --dest=org.kde.plasmashell --type=method_call /PlasmaShell org.kde.PlasmaShell.evaluateScript "string:
        var Desktops = desktops();
        for (i=0; i<Desktops.length; i++) {
            d = Desktops[i];
            d.wallpaperPlugin = 'org.kde.image';
            d.currentConfigGroup = Array('Wallpaper', 'org.kde.image', 'General');
            d.writeConfig('Image', 'file://$SAVE_PATH');
        }
    "

    # 5. Restore Shortcuts (Search for the hidden binary)
    killall kglobalaccel 2>/dev/null
    PATHS=("/usr/lib/x86_64-linux-gnu/libexec/kglobalaccel" "/usr/lib/x86_64-linux-gnu/bin/kglobalaccel" "/usr/bin/kglobalaccel")
    for p in "${PATHS[@]}"; do
        if [ -f "$p" ]; then
            "$p" &
            break
        fi
    done

    echo "✅ Wallpaper updated: wallhaven_$TIMESTAMP.jpg"
else
    echo "❌ Wallhaven API error."
fi
