typeset -U path
path=(~/go/bin ~/.yarn/bin $path[@])

export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true
export EDITOR='vim'
export ENABLE_CORRECTION=true
export ZSH=~/.oh-my-zsh

ZSH_THEME='greg'

plugins=(docker git ng npm yarn)

source $ZSH/oh-my-zsh.sh

setopt nobeep

alias dotnet='TERM=xterm dotnet' # https://github.com/dotnet/corefx/issues/26966
alias ls='ls --color=auto --group-directories-first --human-readable'
alias gogh='wget -O gogh https://git.io/vQgMr && chmod +x gogh && ./gogh && rm gogh'

