#!/bin/bash

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOST=$(uname -n)

# Config
stow -d "$DOTFILES" -t ~/.config config --no-folding
stow -d "$DOTFILES" -t ~ home

# Host-specific config
stow -d "$DOTFILES/hosts/$HOST" -t ~/.config config --no-folding
stow -d "$DOTFILES/hosts/$HOST" -t ~ home

# Scripts
stow -d "$DOTFILES" -t ~/.local/bin utils

echo "All symlinks created!"

# Theme
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.desktop.wm.preferences button-layout ':' # Remove close button
matugen image "$DOTFILES/wallpapers/tomosaki.jpg"

echo "Applied theme!"
