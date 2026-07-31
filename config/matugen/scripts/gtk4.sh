#!/usr/bin/env bash

mode="$1"

if [[ "$mode" == "dark" ]]; then
    gsettings set org.gnome.desktop.interface color-scheme prefer-light
    sleep 0.05
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark
else
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark
    sleep 0.05
    gsettings set org.gnome.desktop.interface color-scheme prefer-light
fi
