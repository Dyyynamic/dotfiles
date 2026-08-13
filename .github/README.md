# Dotfiles

| ![Screenshot](assets/screenshot-1.png)<br>**Dark Mode**        | ![Screenshot](assets/screenshot-2.png)<br>**Light Mode** |
| :------------------------------------------------------------: | :------------------------------------------------------: |
| ![Screenshot](assets/screenshot-3.png)<br>**Wallpaper Picker** | ![Screenshot](assets/screenshot-4.png)<br>**Lockscreen** |

**Personal desktop configuration for Arch Linux**

## Components

| Component     | Name                                                        |
| ------------- | ----------------------------------------------------------- |
| Compositor    | [Hyprland](https://hypr.land/)                              |
| Desktop Shell | [Quickshell](https://github.com/Dyyynamic/shell)            |
| Launcher      | [Walker](https://github.com/abenz1267/walker)               |
| Wallpaper     | [Awww](https://codeberg.org/LGFae/awww)                     |
| Theme         | [Matugen](https://github.com/InioX/matugen)                 |
| Terminal      | [Ghostty](https://ghostty.org/)                             |
| Shell         | Zsh + [Starship](https://starship.rs/)                      |

## Installation

> [!IMPORTANT]
> This script assumes a fresh Arch Linux installation with a running Hyprland session.

> [!TIP]
> When installing Arch, install Hyprland and greetd for a minimal starting
point. Disable any other display managers (such as GDM or SDDM) to use the
included greetd setup.

Run the setup script:

```bash
curl -fsSL https://raw.githubusercontent.com/Dyyynamic/dotfiles/hypr/setup.sh | bash
```

Host-specific configs (monitors, default apps, etc.) can be modified under `~/.dotfiles/hosts/<hostname>`.
