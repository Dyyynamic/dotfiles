#!/bin/bash

# Get the number of available updates
UPDATES=$(checkupdates | wc -l)

# If there are updates, send a notification
if [ "$UPDATES" -gt 0 ]; then
    notify-send -a "Arch Linux" "Software Updates Available" "$UPDATES updates available"
fi
