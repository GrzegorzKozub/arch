typeset -U path
path=(~/.yarn/bin $path[@])

export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true
export EDITOR='vim'
export ZSH=~/.oh-my-zsh

ZSH_THEME=''

plugins=(
  git
)

source $ZSH/oh-my-zsh.sh

setopt nobeep

alias dotnet='TERM=xterm dotnet' # https://github.com/dotnet/corefx/issues/26966
alias ls='ls --color=auto --group-directories-first --human-readable'
