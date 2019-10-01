typeset -U path
path=(~/.gem/ruby/2.6.0/bin ~/.local/bin ~/.yarn/bin ~/go/bin $path[@])

export DOTNET_CLI_TELEMETRY_OPTOUT=1
export EDITOR='vim'
export ENABLE_CORRECTION=true
export ERL_AFLAGS='-kernel shell_history enabled'
export ZSH=~/.oh-my-zsh

ZSH_THEME='greg'

plugins=(docker docker-compose docker-machine golang httpie mix npm yarn zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

setopt nobeep

alias ls='ls --color=auto --group-directories-first --human-readable'

autoload edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

