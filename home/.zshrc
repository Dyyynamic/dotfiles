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
export FZF_DEFAULT_OPTS="--border"

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
bindkey '^[[3~' delete-char      # Delete

# Open in file manager with Ctrl+E
open_nautilus() {
  nautilus &>/dev/null . &!
}
zle -N open_nautilus
bindkey '^e' open_nautilus

fastfetch

# LaTeX Perl paths for biber
export PATH="/usr/bin/vendor_perl:/usr/bin/site_perl:/usr/bin/core_perl:$PATH"

# pnpm
export PNPM_HOME="/home/dynamic/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
