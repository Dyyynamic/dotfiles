#!/bin/bash

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOST=$(uname -n)

link() {
    local src="$1"
    local dest="$2"

    # Skip if the source file doesn't exist
    if [[ ! -e "$src" ]]; then
        echo "Skipping non-existent source: $src"
        return 0
    fi

    mkdir -p "$(dirname "$dest")"

    # Skip if already linked
    if [[ -L "$dest" ]]; then
        local target
        target="$(readlink "$dest")"
        if [[ "$target" = "$src" ]]; then
            echo "Already linked: $dest"
            return 0
        fi
    fi

    # Backup if file already exists
    if [[ -e "$dest" ]] || [[ -L "$dest" ]]; then
        echo "Backing up existing path: $dest -> $dest.bak"
        mv "$dest" "$dest.bak"
    fi

    echo "Linking $src -> $dest"
    ln -s "$src" "$dest"
}

# Host-specific configs
link "$DOTFILES/hosts/$HOST/bookmarks" "$DOTFILES/gtk-3.0/bookmarks"
link "$DOTFILES/hosts/$HOST/monitors.conf" "$DOTFILES/hypr/monitors.conf"
link "$DOTFILES/hosts/$HOST/default_apps.conf" "$DOTFILES/hypr/default_apps.conf"
link "$DOTFILES/hosts/$HOST/env.conf" "$DOTFILES/hypr/env.conf"
link "$DOTFILES/hosts/$HOST/zsh_aliases" "$HOME/.zsh_aliases"

# User-specific configs
link "$DOTFILES/avatar.png" "$DOTFILES/hypr/avatar.png"

# Configs
link "$DOTFILES/better-control" "$HOME/.config/better-control"
link "$DOTFILES/fastfetch" "$HOME/.config/fastfetch"
link "$DOTFILES/ghostty" "$HOME/.config/ghostty"
link "$DOTFILES/gtk-3.0" "$HOME/.config/gtk-3.0"
link "$DOTFILES/gtk-4.0" "$HOME/.config/gtk-4.0"
link "$DOTFILES/hypr" "$HOME/.config/hypr"
link "$DOTFILES/matugen" "$HOME/.config/matugen"
link "$DOTFILES/swaync" "$HOME/.config/swaync"
link "$DOTFILES/swayosd" "$HOME/.config/swayosd"
link "$DOTFILES/walker" "$HOME/.config/walker"
link "$DOTFILES/waybar" "$HOME/.config/waybar"
link "$DOTFILES/zshrc" "$HOME/.zshrc"
link "$DOTFILES/starship.toml" "$HOME/.config/starship.toml"

# Scripts
link "$DOTFILES/utils/update-notifier.sh" "$HOME/.local/bin/update-notifier"

echo "All symlinks created!"

# Theme
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.desktop.wm.preferences button-layout ':' # Remove close button
matugen image "$DOTFILES/wallpapers/tomosaki.jpg"

echo "Applied theme!"
