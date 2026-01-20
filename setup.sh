#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

# Configs
link "$DOTFILES_DIR/fastfetch" "$HOME/.config/fastfetch"
link "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"
link "$DOTFILES_DIR/hypr" "$HOME/.config/hypr"
link "$DOTFILES_DIR/matugen" "$HOME/.config/matugen"
link "$DOTFILES_DIR/swaync" "$HOME/.config/swaync"
link "$DOTFILES_DIR/walker" "$HOME/.config/walker"
link "$DOTFILES_DIR/waybar" "$HOME/.config/waybar"
link "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
link "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"

# Scripts
link "$DOTFILES_DIR/utils/change-wallpaper.sh" "$HOME/.local/bin/change-wallpaper"
link "$DOTFILES_DIR/utils/update-notifier.sh" "$HOME/.local/bin/update-notifier"

echo "All symlinks created!"
