#!/bin/bash

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOST=$(uname -n)

link() {
    local src="$1"
    local dest="$2"

    mkdir -p "$(dirname "$dest")"

    if [ -L "$dest" ]; then
        local target
        target="$(readlink "$dest")"
        if [ "$target" = "$src" ]; then
            echo "Already linked: $dest"
            return 0
        fi
    fi

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        echo "Backing up existing path: $dest -> $dest.bak"
        mv "$dest" "$dest.bak"
    fi

    echo "Linking $src -> $dest"
    ln -s "$src" "$dest"
}

# Host-specific configs
ln -sf "$DOTFILES/hosts/$HOST/monitors.conf" "$DOTFILES/hypr/monitors.conf"

# Configs
link "$DOTFILES/fastfetch" "$HOME/.config/fastfetch"
link "$DOTFILES/ghostty" "$HOME/.config/ghostty"
link "$DOTFILES/hypr" "$HOME/.config/hypr"
link "$DOTFILES/matugen" "$HOME/.config/matugen"
link "$DOTFILES/swaync" "$HOME/.config/swaync"
link "$DOTFILES/walker" "$HOME/.config/walker"
link "$DOTFILES/waybar" "$HOME/.config/waybar"
link "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
link "$DOTFILES/starship.toml" "$HOME/.config/starship.toml"

# Scripts
link "$DOTFILES/utils/change-wallpaper.sh" "$HOME/.local/bin/change-wallpaper"
link "$DOTFILES/utils/update-notifier.sh" "$HOME/.local/bin/update-notifier"

echo "All symlinks created!"
