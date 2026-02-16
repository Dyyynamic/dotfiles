# History
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Exports
export PATH="$HOME/.local/bin:$PATH"

# Command Completion
zstyle :compinstall filename '/home/dynamic/.zshrc'
autoload -Uz compinit
compinit

# Starship
eval "$(starship init zsh)"

# Plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Aliases
alias ls="ls --color=auto"
alias grep="grep --color=auto"
alias diff="diff --color=auto"
alias ff="fastfetch"

# Host-specific aliases
if [[ -f "$HOME/.zsh_aliases" ]]; then
    source "$HOME/.zsh_aliases"
fi

# Keybinds
bindkey '\e[1;5C' forward-word   # Ctrl + Right
bindkey '\e[1;5D' backward-word  # Ctrl + Left
bindkey '^H' backward-kill-word  # Ctrl + Backspace
bindkey '^[[3;5~' kill-word      # Ctrl + Delete

fastfetch

# pnpm
export PNPM_HOME="/home/dynamic/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
