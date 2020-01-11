# zsh 

typeset -U path
path=(~/.local/bin ~/.npm/bin ~/go/bin ~/.gem/ruby/2.6.0/bin $path[@])

export EDITOR='vim'
setopt nobeep

stty -ixon

# fzf

export FZF_DEFAULT_OPTS='
  --color dark,bg+:-1,fg:10,fg+:14,hl:13,hl+:13
  --color spinner:8,info:8,prompt:10,pointer:14,marker:14
'

# zsh-syntax-highlighting

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]='none'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green'

# zsh-vim-mode

MODE_CURSOR_SEARCH='steady block'
MODE_CURSOR_VICMD='blinking block'
MODE_CURSOR_VIINS='blinking bar'

# ranger

function ranger-cd {
  TMP="$(mktemp)"
  ranger --choosedir="$TMP" "$@" < $TTY
  if [ -f "$TMP" ]; then
    DIR="$(cat "$TMP")"
    rm -f "$TMP"
    [ -d "$DIR" ] && [ "$DIR" != "$(pwd)" ] && cd "$DIR"
    unset DIR
  fi
  unset TMP
  zle reset-prompt
}

zle -N ranger-cd

bindkey -M vicmd '\er' ranger-cd
bindkey -M viins '\er' ranger-cd

# screen

function screen {
  if [[ $(xrandr | grep connected | grep 3840x2160) ]]; then FACTOR=1.75; else FACTOR=1.25; fi
  gsettings set org.gnome.desktop.interface text-scaling-factor $FACTOR
  unset FACTOR
}

# oh-my-zsh

export ENABLE_CORRECTION=true
export ZSH=~/.oh-my-zsh
ZSH_THEME='greg'

plugins=(
  last-working-dir
  copydir copyfile web-search
  ripgrep systemd
  git git-extras
  dotnet golang mix npm pip python dotnet
  aws docker docker-compose docker-machine kubectl
  zsh-vim-mode # after aws
  dirhistory fzf # after zsh-vim-mode
  zsh-syntax-highlighting # last
)

source $ZSH/oh-my-zsh.sh

# dotnet

export DOTNET_CLI_TELEMETRY_OPTOUT=1

# erlang

export ERL_AFLAGS='-kernel shell_history enabled'

