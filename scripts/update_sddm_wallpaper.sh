#!/bin/bash
# update_sddm_wallpaper.sh - Apply latest wallhaven wallpaper to SDDM only

SAVE_DIR="$HOME/Pictures/Wallpapers"
LATEST_WP=$(ls -t "$SAVE_DIR"/wallhaven_*.jpg 2>/dev/null | head -n1)

if [ -z "$LATEST_WP" ] || [ ! -f "$LATEST_WP" ]; then
    echo "❌ No wallhaven wallpaper found in $SAVE_DIR"
    echo "Run your wallhaven script first."
    exit 1
fi

echo "📱 Found latest: $(basename "$LATEST_WP")"
echo "Updating SDDM (Breeze theme)..."

# SDDM config override
sudo tee /etc/sddm.conf.d/10-wallpaper.conf > /dev/null << EOF
[Theme]
Current=breeze
Background=file://$LATEST_WP
EOF

# Restart SDDM
echo "🔄 Restarting SDDM (logs you out)..."
sudo systemctl restart sddm

echo "✅ SDDM updated to $LATEST_WP"

