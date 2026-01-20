#!/bin/bash

WALLPAPER="$1"
if [[ -z "$WALLPAPER" ]]; then
    echo "Usage: $0 /path/to/wallpaper.jpg"
    exit 1
fi

HYPRPAPER_CONF="$(readlink -f "$HOME/.config/hypr/hyprpaper.conf")"
HYPRLOCK_CONF="$(readlink -f "$HOME/.config/hypr/hyprlock.conf")"

# Generate new palette
matugen image $WALLPAPER

# Update wallpaper in memory
hyprctl hyprpaper wallpaper ,"$WALLPAPER"

# Update hyprpaper config
gawk -i inplace -v new_bg="$WALLPAPER" '
/path[[:space:]]*=/ { sub(/=.*/, "= " new_bg) }
{ print }
' "$HYPRPAPER_CONF"

# Update hyprlock config
gawk -i inplace -v new_bg="$WALLPAPER" '
/background {/ { in_bg=1 }
/}/ { in_bg=0 }
in_bg && /path[[:space:]]*=/ { sub(/=.*/, "= " new_bg) }
{ print }
' "$HYPRLOCK_CONF"
