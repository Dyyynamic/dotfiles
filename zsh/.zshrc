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

# Aliases
alias ls="ls --color=auto"
alias grep="grep --color=auto"
alias neofetch="fastfetch"
alias w++17="g++ -std=c++17 -Wall -Wextra -pedantic -Weffc++ -Wold-style-cast -Woverloaded-virtual -fmax-errors=3 -g"
alias eduroam="sudo wpa_supplicant -i wlan0 -c /etc/wpa_supplicant/eduroam.conf"

bindkey '\e[1;5C' forward-word   # Ctrl + Right
bindkey '\e[1;5D' backward-word  # Ctrl + Left
bindkey '^H' backward-kill-word  # Ctrl + Backspace
bindkey '^[[3;5~' kill-word      # Ctrl + Delete
