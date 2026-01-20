#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
    local src="$1"
    local dest="$2"

    mkdir -p "$(dirname "$dest")"

    if [ -L "$dest" ]; then
        echo "Removing old symlink: $dest"
        rm "$dest"
    elif [ -e "$dest" ]; then
        echo "Backing up existing file: $dest -> $dest.bak"
        mv "$dest" "$dest.bak"
    fi

    echo "Linking $src -> $dest"
    ln -s "$src" "$dest"
}

# Fastfetch
link "$DOTFILES_DIR/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"
link "$DOTFILES_DIR/fastfetch/copland-logo.txt" "$HOME/.config/fastfetch/copland-logo.txt"

# Ghostty
link "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"
link "$DOTFILES_DIR/ghostty/themes/Matugen" "$HOME/.config/ghostty/themes/Matugen"

# Hyprland
link "$DOTFILES_DIR/hypr/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
link "$DOTFILES_DIR/hypr/hyprlock.conf" "$HOME/.config/hypr/hyprlock.conf"
link "$DOTFILES_DIR/hypr/hyprpaper.conf" "$HOME/.config/hypr/hyprpaper.conf"
link "$DOTFILES_DIR/hypr/hyprsunset.conf" "$HOME/.config/hypr/hyprsunset.conf"
link "$DOTFILES_DIR/hypr/colors.conf" "$HOME/.config/hypr/colors.conf"

# SwayNotificationCenter
link "$DOTFILES_DIR/swaync/config.json" "$HOME/.config/swaync/config.json"
link "$DOTFILES_DIR/swaync/style.css" "$HOME/.config/swaync/style.css"
link "$DOTFILES_DIR/swaync/colors.css" "$HOME/.config/swaync/colors.css"

# Walker
link "$DOTFILES_DIR/walker/config.toml" "$HOME/.config/walker/config.toml"
link "$DOTFILES_DIR/walker/themes/Matugen/style.css" "$HOME/.config/walker/themes/Matugen/style.css"
link "$DOTFILES_DIR/walker/themes/Matugen/colors.css" "$HOME/.config/walker/themes/Matugen/colors.css"

# Waybar
link "$DOTFILES_DIR/waybar/config" "$HOME/.config/waybar/config"
link "$DOTFILES_DIR/waybar/style.css" "$HOME/.config/waybar/style.css"
link "$DOTFILES_DIR/waybar/colors.css" "$HOME/.config/waybar/colors.css"

# Zsh
link "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

# Starship
link "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"

# Scripts
link "$DOTFILES_DIR/utils/change-wallpaper.sh" "$HOME/.local/bin/change-wallpaper"
link "$DOTFILES_DIR/utils/update-notifier.sh" "$HOME/.local/bin/update-notifier"

echo "All symlinks created!"
