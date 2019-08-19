typeset -U path
path=(~/.gem/ruby/2.6.0/bin ~/.local/bin ~/.yarn/bin ~/go/bin $path[@])

export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true
export EDITOR='vim'
export ENABLE_CORRECTION=true
export ZSH=~/.oh-my-zsh

ZSH_THEME='greg'

plugins=(docker yarn)

source $ZSH/oh-my-zsh.sh

setopt nobeep

alias ls='ls --color=auto --group-directories-first --human-readable'
