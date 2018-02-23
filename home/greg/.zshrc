typeset -U path
path=(~/.yarn/bin $path[@])

export EDITOR='vim'
export ZSH=~/.oh-my-zsh

ZSH_THEME=''

plugins=(
  git
)

source $ZSH/oh-my-zsh.sh

setopt nobeep

alias ls='ls --color=auto --group-directories-first --human-readable'
