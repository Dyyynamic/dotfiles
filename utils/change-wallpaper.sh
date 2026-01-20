#!/bin/bash

WALLPAPER="$1"
if [[ -z "$WALLPAPER" ]]; then
    echo "Usage: $0 /path/to/wallpaper.jpg"
    exit 1
fi

# Generate new palette
matugen image $WALLPAPER

# Update wallpaper in memory
hyprctl hyprpaper wallpaper ,"$WALLPAPER"

# Update hyprpaper config
gawk -i inplace -v new_bg="$WALLPAPER" '
/path[[:space:]]*=/ { sub(/=.*/, "= " new_bg) }
{ print }
' "$HOME/.config/hypr/hyprpaper.conf"

# Update hyprlock config
gawk -i inplace -v new_bg="$WALLPAPER" '
/background {/ { in_bg=1 }
/}/ { in_bg=0 }
in_bg && /path[[:space:]]*=/ { sub(/=.*/, "= " new_bg) }
{ print }
' "$HOME/.config/hypr/hyprlock.conf"
