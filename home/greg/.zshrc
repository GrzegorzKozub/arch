# paths
typeset -U path
path=(~/.local/bin ~/.npm/bin ~/go/bin ~/.gem/ruby/2.6.0/bin $path[@])

# colors

autoload -U colors && colors

if [[ -z "$LS_COLORS" ]] && (( $+commands[dircolors] )); then
  CMD=/tmp/ls_colors.zsh
  if [[ ! -x $CMD ]]; then
    dircolors -b > $CMD && chmod a+x $CMD
  fi
  $CMD
  unset CMD
fi

# terminal
zstyle ':prezto:module:terminal' auto-title 'yes'

# plugins

source ~/.zinit/bin/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light softmoth/zsh-vim-mode

zinit ice wait lucid
zinit snippet OMZ::plugins/fzf/fzf.plugin.zsh # after zsh-vim-mode

zinit snippet OMZ::plugins/last-working-dir/last-working-dir.plugin.zsh
zinit ice wait lucid
zinit snippet OMZ::plugins/dirhistory/dirhistory.plugin.zsh # after zsh-vim-mode

zinit snippet OMZ::lib/git.zsh
zinit snippet https://github.com/GrzegorzKozub/themes/blob/master/zsh/solarized-dark.zsh-theme # after zsh-vim-mode

zinit ice wait lucid
zinit light zdharma/fast-syntax-highlighting
zinit ice wait cloneonly nocompile atclone'fast-theme ./solarized-dark.ini --quiet' atpull'%atclone' lucid
zinit snippet https://github.com/GrzegorzKozub/themes/blob/master/fast-syntax-highlighting/solarized-dark.ini # after fast-syntax-highlighting

zinit snippet PZT::modules/terminal/init.zsh

zinit ice wait lucid as'completion'
zinit snippet OMZ::plugins/docker/_docker
zinit ice wait lucid as'completion'
zinit snippet OMZ::plugins/docker-compose/_docker-compose
zinit ice wait lucid as'completion'
zinit snippet OMZ::plugins/docker-machine/_docker-machine
zinit ice wait lucid as'completion'
zinit snippet OMZ::plugins/pip/_pip

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
setopt complete_in_word # complete from both words ends
setopt extended_glob
setopt path_dirs # search for paths on commands with slashes

zstyle ':completion:*' menu select
zstyle ':completion:*:warnings' format '%F{red}no matches found%f'

# complete environment variables
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

# correct single char typos
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# history

[ -z "$HISTFILE" ] && HISTFILE=~/.zshhist

HISTSIZE=50000
SAVEHIST=10000

setopt extended_history # record timestamps
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify # don't run command immediately
setopt inc_append_history # add commands in the order of execution
setopt share_history # share history between terminals

cp ~/.zshhist ~/Dropbox/Backup

# aliases
alias grep='grep --color=auto --exclude-dir={.git}'
alias ls='ls --color=auto'
alias la='ls -lAh'

# dirhistory
bindkey -M vicmd '^[[1;3D' dirhistory_zle_dirhistory_back
bindkey -M vicmd '^[[1;3C' dirhistory_zle_dirhistory_future
bindkey -M vicmd '^[[1;3A' dirhistory_zle_dirhistory_up
bindkey -M vicmd '^[[1;3B' dirhistory_zle_dirhistory_down

# zsh-vim-mode
MODE_CURSOR_SEARCH='steady block'
MODE_CURSOR_VICMD='blinking block'
MODE_CURSOR_VIINS='blinking bar'

# dotnet
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# erlang
export ERL_AFLAGS='-kernel shell_history enabled'

# fzf
bindkey -M vicmd '^[c' fzf-cd-widget
bindkey -M vicmd '^r' fzf-history-widget
bindkey -M vicmd '^t' fzf-file-widget

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
  if [[ $(xrandr | grep connected | grep 3840x2160) ]]; then FACTOR=1.5; else FACTOR=1.25; fi
  gsettings set org.gnome.desktop.interface text-scaling-factor $FACTOR
  unset FACTOR
}

