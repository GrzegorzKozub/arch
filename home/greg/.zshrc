typeset -U path
path=(~/scripts ~/.local/bin ~/.npm/bin ~/go/bin ~/.gem/ruby/2.6.0/bin $path[@])

export DOTNET_CLI_TELEMETRY_OPTOUT=1
export EDITOR='vim'
export ENABLE_CORRECTION=true
export ERL_AFLAGS='-kernel shell_history enabled'
export ZSH=~/.oh-my-zsh

ZSH_THEME='greg'

plugins=(
  last-working-dir
  zsh-autosuggestions zsh-syntax-highlighting
  copydir copyfile web-search
  ripgrep sudo systemd
  git git-extras
  dotnet golang mix npm pip python dotnet
  aws docker docker-compose docker-machine kubectl
  zsh-vim-mode # after aws for compatibility
  dirhistory fzf # after zsh-vim-mode for compatibility
)

source $ZSH/oh-my-zsh.sh

setopt nobeep

# https://github.com/junegunn/fzf
export FZF_DEFAULT_OPTS='
  --color dark,bg+:-1,fg:10,fg+:14,hl:13,hl+:13
  --color spinner:8,info:8,prompt:10,pointer:14,marker:14
'

# https://github.com/zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
ZSH_AUTOSUGGEST_USE_ASYNC=true

# https://github.com/zsh-users/zsh-syntax-highlighting
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green'
ZSH_HIGHLIGHT_STYLES[path]='none'

# https://github.com/softmoth/zsh-vim-mode
MODE_CURSOR_VICMD='blinking block'
MODE_CURSOR_VIINS='blinking bar'
MODE_CURSOR_SEARCH='steady block'

# https://github.com/ranger/ranger
function ranger-cd {
  TEMPFILE="$(mktemp -t tmp.XXXXXX)"
  /usr/bin/ranger --choosedir="$TEMPFILE" "${@:-$(pwd)}"
  test -f "$TEMPFILE" &&
  if [ "$(cat -- "$TEMPFILE")" != "$(echo -n `pwd`)" ]; then
    cd -- "$(cat "$TEMPFILE")"
  fi  
  rm -f -- "$TEMPFILE"
  unset TEMPFILE
}
