# paths
typeset -U path
path=(~/.local/bin ~/.npm/bin ~/go/bin ~/.gem/ruby/2.6.0/bin $path[@])

# colors
autoload -U colors && colors
if [[ -z "$LS_COLORS" ]]; then (( $+commands[dircolors] )) && eval "$(dircolors -b)"; fi

# plugins

source ~/.zplugin/bin/zplugin.zsh
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin

zplugin snippet OMZ::lib/termsupport.zsh

zplugin light softmoth/zsh-vim-mode

zplugin snippet OMZ::plugins/fzf/fzf.plugin.zsh # after zsh-vim-mode

zplugin snippet OMZ::plugins/dirhistory/dirhistory.plugin.zsh # after zsh-vim-mode
zplugin snippet OMZ::plugins/last-working-dir/last-working-dir.plugin.zsh

zplugin snippet OMZ::lib/git.zsh
zplugin snippet https://github.com/GrzegorzKozub/zsh-themes/blob/master/greg.zsh-theme # after zsh-vim-mode

zplugin light zdharma/fast-syntax-highlighting

zplugin ice as'completion'
zplugin snippet OMZ::plugins/docker/_docker
zplugin ice as'completion'
zplugin snippet OMZ::plugins/docker-compose/_docker-compose
zplugin ice as'completion'
zplugin snippet OMZ::plugins/docker-machine/_docker-machine
zplugin ice as'completion'
zplugin snippet OMZ::plugins/pip/_pip

# options

export EDITOR='vim'

setopt auto_pushd # pushd on every cd
setopt correct_all
setopt no_beep
setopt pushd_ignore_dups
setopt pushd_minus # cd - goes to the previous dir

stty -ixon # disable flow control (^s and ^c)

# prompt
autoload -Uz promptinit && promptinit
setopt prompt_subst

# completion

WORDCHARS=''

autoload -Uz compinit && compinit

setopt always_to_end # put cursor at the end of completed word
setopt auto_menu # show completion menu on 2nd tab
setopt complete_aliases
setopt complete_in_word

zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# history

[ -z "$HISTFILE" ] && HISTFILE=~/.zshhist

HISTSIZE=50000
SAVEHIST=10000

setopt extended_history # record timestamps
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify # don't run command immediately
setopt inc_append_history # add commands in the order of execution
setopt share_history # share history between terminals

# aliases
alias grep="grep --color=auto --exclude-dir={.git}"
alias ls="ls --color=auto"
alias la='ls -lAh'

# zsh-vim-mode
MODE_CURSOR_SEARCH='steady block'
MODE_CURSOR_VICMD='blinking block'
MODE_CURSOR_VIINS='blinking bar'

# dotnet
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# erlang
export ERL_AFLAGS='-kernel shell_history enabled'

# fzf
export FZF_DEFAULT_OPTS='
  --color dark,bg+:-1,fg:10,fg+:14,hl:13,hl+:13
  --color spinner:8,info:8,prompt:10,pointer:14,marker:14
'

# esc+r activates ranger which changes current dir upon exit
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

# larger fonts on 4k screen
function screen {
  if [[ $(xrandr | grep connected | grep 3840x2160) ]]; then FACTOR=1.75; else FACTOR=1.25; fi
  gsettings set org.gnome.desktop.interface text-scaling-factor $FACTOR
  unset FACTOR
}

