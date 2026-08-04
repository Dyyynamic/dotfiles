#!/bin/bash
set -e

DOTFILES="$HOME/.dotfiles"
QUICKSHELL="$HOME/.config/quickshell"
WALLPAPERS="$HOME/Pictures/Wallpapers"
PLUGINS="$HOME/.config/hypr/plugins"
HOST="$DOTFILES/hosts/$(uname -n)"

tasks=(
    install_yay
    clone_dotfiles
    install_packages
    create_user_dirs
    install_hyprland_plugins
    change_shell
    symlink_config
    enable_systemd_services
    set_gsettings
    setup_greeter
    apply_theme
)

include=()
exclude=()

install_yay() {
    echo "Installing yay..."

    if ! command -v yay &>/dev/null; then
        sudo pacman -S --needed --noconfirm git base-devel
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        (cd /tmp/yay && makepkg -si --noconfirm)
        rm -rf /tmp/yay
    fi
}

clone_dotfiles() {
    echo "Cloning dotfiles..."

    mkdir -p "$HOME/.config"

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
}

install_packages() {
    echo "Installing required packages..."

    yay -S --needed --noconfirm - < "$DOTFILES/pkglist.txt"
}

create_user_dirs() {
    echo "Creating user directories..."

    xdg-user-dirs-update
}

install_hyprland_plugins() {
    echo "Installing Hyprland plugins..."

    mkdir -p "$PLUGINS"

    PLUGIN="$PLUGINS/split-monitor-workspaces"
    if [[ ! -d "$PLUGIN" ]]; then
        git clone https://github.com/zjeffer/split-monitor-workspaces "$PLUGIN"
    else
        git -C "$PLUGIN" pull
    fi
}

change_shell() {
    echo "Changing shell to zsh..."

    if [[ "$SHELL" != "$(which zsh)" ]]; then
        sudo chsh -s $(which zsh) $USER
    fi
}

symlink_config() {
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
}

enable_systemd_services() {
    echo "Enabling systemd services..."

    systemctl --user enable --now tapo.service
    systemctl --user enable --now gcr-ssh-agent.socket
    sudo systemctl enable --now paccache.timer
    sudo systemctl enable --now systemd-oomd
}

set_gsettings() {
    echo "Setting gsettings..."

    gsettings set org.gnome.desktop.wm.preferences button-layout ':'

    # Gthumb
    gsettings set org.gnome.gthumb.browser statusbar-visible false
    gsettings set org.gnome.gthumb.browser scroll-action 'zoom'
    gsettings set org.gnome.gthumb.image-viewer show-frame false
}

setup_greeter() {
    echo "Setting up greeter..."

    sudo systemctl enable greetd.service

    sudo ln -sf "$DOTFILES/greetd/config.toml" "/etc/greetd/config.toml"
    sudo ln -sf "$DOTFILES/greetd/pam" "/etc/pam.d/greetd"

    # Add user to greeter group
    sudo usermod -aG greeter "$USER"

    # Create shared directory
    sudo mkdir -p /var/lib/greetd
    sudo chown -R "${USER}:greeter" /var/lib/greetd
    sudo chmod 2750 /var/lib/greetd

    # Set ACLs so future copied files inherit the group ownership
    sudo setfacl -m g:greeter:rX /var/lib/greetd
    sudo setfacl -d -m g:greeter:rX /var/lib/greetd

    # Copy shared files
    sudo rm -rf "/var/lib/greetd/quickshell"
    cp -r "$QUICKSHELL" "/var/lib/greetd/quickshell"

    cp "$DOTFILES/assets/avatar.png" "/var/lib/greetd/avatar.png"
    cp "$DOTFILES/greetd/hyprland.lua" "/var/lib/greetd/hyprland.lua"

    if [[ -f "$HOST/config/hypr/monitors.lua" ]]; then
        cp "$HOST/config/hypr/monitors.lua" "/var/lib/greetd/monitors.lua"
    fi

    if [[ -f "$HOST/config/hypr/env.lua" ]]; then
        cp "$HOST/config/hypr/env.lua" "/var/lib/greetd/env.lua"
    fi
}

apply_theme() {
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
}

contains() {
    local item="$1"
    shift

    for i in "$@"; do
        [[ "$i" == "$item" ]] && return 0
    done

    return 1
}

exec_tasks() {
    for task in "${tasks[@]}"; do
        # If include list exists, skip anything not in it
        if [[ ${#include[@]} -gt 0 ]] && ! contains "$task" "${include[@]}"; then
            continue
        fi

        # Skip excluded tasks
        if contains "$task" "${exclude[@]}"; then
            continue
        fi

        echo "==> Running $task"
        "$task"
        echo ""
    done
}

main() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --include)
                shift
                while [[ $# -gt 0 && "$1" != --* ]]; do
                    if ! contains "$1" "${tasks[@]}"; then
                        echo "Unknown task: $1"
                        exit 1
                    fi
                    include+=("$1")
                    shift
                done
                ;;
            --exclude)
                shift
                while [[ $# -gt 0 && "$1" != --* ]]; do
                    if ! contains "$1" "${tasks[@]}"; then
                        echo "Unknown task: $1"
                        exit 1
                    fi
                    exclude+=("$1")
                    shift
                done
                ;;
            --list)
                printf '%s\n' "${tasks[@]}"
                exit 0
                ;;
            --help)
                echo "Usage: setup.sh [options]"
                echo ""
                echo "Options:"
                echo "  --include <task>  Run only the specified task(s)"
                echo "  --exclude <task>  Skip the specified task(s)"
                echo "  --list            List all available tasks"
                echo "  --help            Show this help message"
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                exit 1
                ;;
        esac
    done

    if [[ ${#include[@]} -gt 0 && ${#exclude[@]} -gt 0 ]]; then
        echo "Error: --include and --exclude cannot be used together."
        exit 1
    fi

    exec_tasks

    echo "==> Setup complete!"
    echo "⚠ Hyprland needs to reload to launch required tools."
    echo "  Please log out and log back in to finalize the setup."
}

main "$@"
