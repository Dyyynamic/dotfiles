#!/bin/bash
set -e

DOTFILES="$HOME/.dotfiles"
QUICKSHELL="$HOME/.config/quickshell"
WALLPAPERS="$HOME/Pictures/Wallpapers"
PLUGINS="$HOME/.config/hypr/plugins"

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

if [[ ! -d "$QUICKSHELL" ]]; then
    echo "Cloning shell..."
    git clone https://github.com/Dyyynamic/shell.git "$QUICKSHELL"
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

mkdir -p "$PLUGINS"

PLUGIN="$PLUGINS/split-monitor-workspaces"
if [[ ! -d "$PLUGIN" ]]; then
    git clone https://github.com/zjeffer/split-monitor-workspaces "$PLUGIN"
else
    git -C "$PLUGIN" pull
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
rm -f "$HOME/.config/better-control/settings.json"
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

# Systemd services
mkdir -p "$HOME/.config/systemd/user"
stow -d "$DOTFILES" -t "$HOME/.config/systemd/user" systemd

echo "Enabling systemd services..."

systemctl --user enable --now tapo.service
systemctl --user enable --now gcr-ssh-agent.socket
sudo systemctl enable --now paccache.timer
sudo systemctl enable --now systemd-oomd

echo "Setting gsettings..."

gsettings set org.gnome.desktop.wm.preferences button-layout ':'

# Gthumb
gsettings set org.gnome.gthumb.browser statusbar-visible false
gsettings set org.gnome.gthumb.browser scroll-action 'zoom'
gsettings set org.gnome.gthumb.image-viewer show-frame false

echo "Setting up greeter..."

sudo systemctl enable greetd.service

sudo ln -sf "$DOTFILES/greetd/config.toml" "/etc/greetd/config.toml"
sudo ln -sf "$DOTFILES/greetd/pam" "/etc/pam.d/greetd"

# Create shared directory
getent group greetd >/dev/null || sudo groupadd greetd
sudo usermod -aG greetd $USER
sudo usermod -aG greetd greeter
sudo mkdir -p /var/lib/greetd
sudo chown -R "${USER}:greetd" /var/lib/greetd
sudo chmod 2750 /var/lib/greetd

# Copy shared files
sudo rm -rf "/var/lib/greetd/quickshell"
cp -r "$QUICKSHELL" "/var/lib/greetd/quickshell"
cp "$DOTFILES/assets/avatar.png" "/var/lib/greetd/avatar.png"
cp "$DOTFILES/greetd/hyprland.lua" "/var/lib/greetd/hyprland.lua"
cp "$HOST/config/hypr/monitors.lua" "/var/lib/greetd/monitors.lua"
cp "$HOST/config/hypr/env.lua" "/var/lib/greetd/env.lua"

echo "Applying theme..."

# Start daemons

if ! pgrep -x awww-daemon >/dev/null; then
    awww-daemon &>/dev/null &
fi

WALLPAPER="$DOTFILES/assets/wallpaper.jpg"

CURRENT_WALLPAPER=$(
    awww query 2>/dev/null |
    sed -n "s/.*image: \(.*\)$/\1/p" |
    head -n 1
)

if [[ -f "$CURRENT_WALLPAPER" ]]; then
    WALLPAPER="$CURRENT_WALLPAPER"
fi

papirus-folders -C matugen --theme Papirus
matugen image "$WALLPAPER" --source-color-index 0

echo "Setup complete!"
echo "⚠ Hyprland needs to reload to launch required tools."
echo "Please log out and log back in to finalize the setup."
