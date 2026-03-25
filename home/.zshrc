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

fastfetch
