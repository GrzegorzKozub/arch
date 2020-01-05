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

# https://github.com/zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
ZSH_AUTOSUGGEST_USE_ASYNC=true

# https://github.com/softmoth/zsh-vim-mode
MODE_CURSOR_VICMD="blinking block"
MODE_CURSOR_VIINS="blinking bar"
MODE_CURSOR_SEARCH="steady block"
