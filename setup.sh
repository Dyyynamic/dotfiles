#!/bin/bash
set -e

DOTFILES="$HOME/.dotfiles"
WALLPAPERS="$HOME/Pictures/Wallpapers"

echo "Installing yay..."

if ! command -v yay &>/dev/null; then
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
    rm -rf /tmp/yay
fi

echo "Cloning dotfiles..."

if [[ ! -d "$DOTFILES" ]]; then
    git clone https://github.com/Dyyynamic/dotfiles.git "$DOTFILES"
fi

if [[ ! -d "$WALLPAPERS" ]]; then
    read -rp "Clone wallpapers? [Y/n] " choice
    choice=${choice:-Y}

    if [[ "$choice" =~ ^[Yy]$ ]]; then
        echo "Cloning wallpapers..."
        git clone https://github.com/Dyyynamic/wallpapers.git "$WALLPAPERS"
    else
        mkdir -p "$WALLPAPERS"
    fi
fi

echo "Installing required packages..."

yay -S --needed --noconfirm - < "$DOTFILES/pkglist.txt"

echo "Creating home folders..."

xdg-user-dirs-update

echo "Installing Hyprland plugins..."

if ! hyprpm list | grep -q split-monitor-workspaces; then
    hyprpm update
    echo "y" | hyprpm add https://github.com/zjeffer/split-monitor-workspaces
    hyprpm enable split-monitor-workspaces
fi

echo "Changing shell to zsh..."

if [[ "$SHELL" != "$(which zsh)" ]]; then
    sudo chsh -s $(which zsh) $USER
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

# Zen
if [[ ! -d "$HOME/.config/zen" ]]; then
    zen-browser --headless &>/dev/null &
    PID=$!
    sleep 1
    kill $PID
fi

PROFILE=$(
    find "$HOME/.config/zen" \
        -maxdepth 1 \
        -type d \
        -name "*.Default (release)" \
    | head -n 1
)
stow -d "$DOTFILES" -t "$PROFILE" zen

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
mkdir -p "$HOME/.local/bin"
stow -d "$DOTFILES" -t "$HOME/.local/bin" scripts

echo "Enabling systemd services..."

systemctl --user enable --now gcr-ssh-agent.socket
sudo systemctl enable --now paccache.timer
sudo systemctl enable --now systemd-oomd

echo "Setting gsettings..."

gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.desktop.wm.preferences button-layout ':'

echo "Applying theme..."

# Start daemons

if ! pgrep -x awww-daemon >/dev/null; then
    awww-daemon &>/dev/null &
fi

if ! pgrep -x swaync >/dev/null; then
    pkill dunst || true # Included by archinstall
    swaync &>/dev/null &
fi

WALLPAPER="$DOTFILES/wallpapers/winter-road.png"

CURRENT_WALLPAPER=$(
    awww query 2>/dev/null |
    sed -n "s/.*image: \(.*\)$/\1/p" |
    head -n 1
)

if [[ -f "$CURRENT_WALLPAPER" ]]; then
    WALLPAPER="$CURRENT_WALLPAPER"
fi

matugen image "$WALLPAPER" --source-color-index 0
papirus-folders -C matugen --theme Papirus

echo "Setup complete!"
echo "⚠ Hyprland needs to reload to launch required tools."
echo "Please log out and log back in to finalize the setup."
