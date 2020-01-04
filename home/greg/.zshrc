typeset -U path
path=(~/.gem/ruby/2.6.0/bin ~/.local/bin ~/go/bin ~/.npm/bin $path[@])

export DOTNET_CLI_TELEMETRY_OPTOUT=1
export EDITOR='vim'
export ENABLE_CORRECTION=true
export ERL_AFLAGS='-kernel shell_history enabled'
export ZSH=~/.oh-my-zsh

ZSH_THEME='greg'

plugins=(
  aws
  copyfile
  dirhistory
  docker
  docker-compose
  docker-machine
  encode64
  extract
  git-extras
  golang
  fzf
  history
  kubectl
  last-working-dir
  mix
  ng
  npm
  pip
  python
  sudo
  systemd
  urltools
  vscode
  web-search
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

setopt nobeep

autoload edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

# https://github.com/junegunn/fzf/wiki/Color-schemes
export FZF_DEFAULT_OPTS='
  --color dark,hl:33,hl+:37,fg+:235,bg+:136,fg+:254
  --color info:254,prompt:37,spinner:108,pointer:235,marker:235
'
# https://github.com/zsh-users/zsh-syntax-highlighting/tree/master/highlighters/main
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green'
ZSH_HIGHLIGHT_STYLES[path]='none'

function screen {
  if [[ $(xrandr | grep connected | grep 3840x2160) ]]; then FACTOR=1.75; else FACTOR=1.25; fi
  gsettings set org.gnome.desktop.interface text-scaling-factor $FACTOR
  unset FACTOR
}
