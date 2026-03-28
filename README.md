# Dotfiles (Hyprland)

![Screenshot](screenshot.png)

**Personal Hyprland setup on Arch Linux**

## Components

| Type          | Name                                                           |
| ------------- | -------------------------------------------------------------- |
| Compositor    | [Hyprland](https://hypr.land/)                                 |
| Bar           | [Waybar](https://github.com/Alexays/Waybar)                    |
| Launcher      | [Walker](https://github.com/abenz1267/walker)                  |
| Notifications | [SwayNC](https://github.com/ErikReider/SwayNotificationCenter) |
| Wallpaper     | [Awww](https://codeberg.org/LGFae/awww)                        |
| Lock Screen   | [Hyprlock](https://wiki.hypr.land/Hypr-Ecosystem/hyprlock/)    |
| Theme         | [Matugen](https://github.com/InioX/matugen)                    |
| Terminal      | [Ghostty](https://ghostty.org/)                                |
| Shell         | Zsh + [Starship](https://starship.rs/)                         |

## Installation

> [!IMPORTANT]
> This script assumes a fresh Arch Linux installation with a running Hyprland session.

Run the setup script:

```bash
curl -fsSL https://raw.githubusercontent.com/Dyyynamic/dotfiles/hypr/setup.sh | bash
```

Host-specific configs (monitors, default apps, etc.) can be modified under `~/.dotfiles/hosts/<hostname>`.

## Usage

Change wallpaper using matugen:

```bash
matugen image /path/to/wallpaper.jpg
```
