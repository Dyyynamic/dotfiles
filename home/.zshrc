# Host-specific configs
[[ -f "$HOME/.zsh_aliases" ]] && source "$HOME/.zsh_aliases"
[[ -f "$HOME/.zsh_env" ]] && source "$HOME/.zsh_env"

# History
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Command Completion
zstyle :compinstall filename '/home/dynamic/.zshrc'
autoload -Uz compinit
compinit

# Starship
eval "$(starship init zsh)"

# Plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source <(fzf --zsh)

export FZF_DEFAULT_COMMAND='fd'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--border --color=16"

# Aliases
alias ls="ls --color=auto"
alias grep="grep --color=auto"
alias diff="diff --color=auto"
alias ff="fastfetch"
alias zed="zeditor"

# Keybinds
bindkey '\e[1;5C' forward-word   # Ctrl + Right
bindkey '\e[1;5D' backward-word  # Ctrl + Left
bindkey '^H' backward-kill-word  # Ctrl + Backspace
bindkey '^[[3;5~' kill-word      # Ctrl + Delete
bindkey '^[[3~' delete-char      # Delete

# Open in file manager with Ctrl+E
open_nautilus() {
    nautilus . &>/dev/null &!
}
zle -N open_nautilus
bindkey '^e' open_nautilus

# ls for images
lsi() {
    local files=$(find "$@" -maxdepth 1 -type f \
        \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \
        -o -iname "*.gif" -o -iname "*.webp" \) \
    | sort)

    if [[ -n "$files" ]]; then
        timg -I --grid=5 --title=%b -f - <<< "$files"
    fi
}

# Random fastfetch logo
fastfetch() {
  LOGO_DIR="$HOME/.config/fastfetch/logos"

    case $(shuf -n1 -e nerv copland yorha arasaka) in
        nerv)
            LOGO="$LOGO_DIR/nerv.txt"
            QUOTE="GOD'S IN HIS HEAVEN. ALL'S RIGHT WITH THE WORLD."
            ;;
        copland)
            LOGO="$LOGO_DIR/copland.txt"
            QUOTE="Let's all love Lain!"
            ;;
        yorha)
            LOGO="$LOGO_DIR/yorha.txt"
            QUOTE="For the Glory of Mankind"
            ;;
        arasaka)
            LOGO="$LOGO_DIR/arasaka.txt"
            QUOTE="A Bright Future, Together."
            ;;
    esac

    FASTFETCH_QUOTE="$QUOTE" command fastfetch --logo "$LOGO"
}

fastfetch
