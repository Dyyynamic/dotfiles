#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOST="$DOTFILES/hosts/$(uname -n)"

# Install yay
if ! command -v yay &> /dev/null; then
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    rm -rf yay
fi

# Install requirements
yay -S --needed --noconfirm - < "$DOTFILES/requirements.txt"

# Install split-monitor-workspaces
if ! hyprpm list | grep -q split-monitor-workspaces; then
    hyprpm add https://github.com/Duckonaut/split-monitor-workspaces
    hyprpm enable split-monitor-workspaces
    hyprpm reload
fi

# Change shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
fi

# Systemd services
sudo systemctl enable --now swayosd-libinput-backend.service
systemctl --user enable --now gcr-ssh-agent.socket

# Config
stow -d "$DOTFILES" -t ~/.config config --no-folding
stow -d "$DOTFILES" -t ~ home

# Host-specific config
if [ -d "$HOST/config" ]; then
    stow -d "$HOST" -t ~/.config config --no-folding
fi
if [ -d "$HOST/home" ]; then
    stow -d "$HOST" -t ~ home
fi

# Scripts
stow -d "$DOTFILES" -t ~/.local/bin scripts

echo "All symlinks created!"

# Theme
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.desktop.wm.preferences button-layout ':' # Remove window buttons
matugen image "$DOTFILES/wallpapers/tomosaki.jpg"

echo "Applied theme!"
