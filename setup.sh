#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing yay..."

if ! command -v yay &> /dev/null; then
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    rm -rf yay
fi

echo "Installing required packages..."

yay -S --needed --noconfirm - < "$DOTFILES/requirements.txt"

echo "Installing Hyprland plugins..."

if ! hyprpm list | grep -q split-monitor-workspaces; then
    hyprpm add https://github.com/Duckonaut/split-monitor-workspaces
    hyprpm enable split-monitor-workspaces
    hyprpm reload
fi

echo "Changing shell to zsh..."

if [[ "$SHELL" != "$(which zsh)" ]]; then
    chsh -s "$(which zsh)"
fi

echo "Symlinking config files..."

# Remove default hyprland config
HYPRLAND="$HOME/.config/hypr/hyprland.conf"
if [[ -f "$HYPRLAND" && ! -L "$HYPRLAND" ]]; then
    rm "$HYPRLAND"
fi

# Config
stow -d "$DOTFILES" -t "$HOME/.config" config --no-folding
stow -d "$DOTFILES" -t "$HOME" home

# Host-specific config
HOST="$DOTFILES/hosts/$(uname -n)"

if [[ ! -d "$HOST" ]]; then
    echo "No host-specific config detected, scaffolding..."
    cp -r "$DOTFILES/hosts/default" "$HOST"
fi

if [[ -d "$HOST/config" ]]; then
    stow -d "$HOST" -t "$HOME/.config" config --no-folding
fi

if [[ -d "$HOST/home" ]]; then
    stow -d "$HOST" -t "$HOME" home
fi

# Scripts
stow -d "$DOTFILES" -t "$HOME/.local/bin" scripts

echo "Enabling systemd services..."

systemctl --user enable --now gcr-ssh-agent.socket

echo "Setting gsettings..."

gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.desktop.wm.preferences button-layout ':' # Remove window buttons

echo "Applying theme..."

# Start swww-daemon
if ! pgrep -x swww-daemon >/dev/null; then
    swww-daemon 2>/dev/null &
fi

WALLPAPER="$DOTFILES/wallpapers/tomosaki.jpg"

CURRENT_WALLPAPER=$(
    swww query 2>/dev/null |
    sed -n "s/.*image: \(.*\)$/\1/p" |
    head -n 1
)

if [[ -f "$CURRENT_WALLPAPER" ]]; then
    WALLPAPER="$CURRENT_WALLPAPER"
fi

matugen image "$WALLPAPER" --quiet

echo "Setup complete!"
echo "⚠ Hyprland needs to reload to launch required tools."
echo "Please log out and log back in to finalize the setup."
