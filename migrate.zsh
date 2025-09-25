#!/usr/bin/env zsh

set -o verbose

# gnome

rm -rf $XDG_DATA_HOME/gnome-shell/extensions/panel@grzegorzkozub.github.com
[[ $HOST = 'drifter' ]] && sudo pacman -S --noconfirm brightnessctl && brightnessctl set 25%

# heic

sudo pacman -S --noconfirm libheif

# vscode

code --uninstall-extension ms-python.vscode-python-envs --force

# nvim

# rm -rf $XDG_CACHE_HOME/nvim
# rm -rf $XDG_DATA_HOME/nvim
# rm -rf ~/.local/state/nvim
# nvim \
#   -c 'autocmd User MasonToolsUpdateCompleted quitall' \
#   -c 'autocmd User VeryLazy MasonToolsUpdate'

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

