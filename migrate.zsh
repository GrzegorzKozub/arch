#!/usr/bin/env zsh

set -o verbose

# gnome

rm -rf $XDG_DATA_HOME/gnome-shell/extensions/panel@grzegorzkozub.github.com
gsettings reset org.gnome.shell enabled-extensions

# heic

sudo pacman -S --noconfirm libheif

# keyring

secret-tool clear app_id ""
secret-tool clear application Slack

# app_id brave-browser
# app_id org.chromium.Chromium

# python

rm -rf $XDG_DATA_HOME/doc
rm -rf $XDG_DATA_HOME/jupyter

# settings

[[ $HOST = 'drifter' ]] && sudo pacman -S --noconfirm brightnessctl && brightnessctl set 25%

# vscode

code --uninstall-extension ms-azuretools.vscode-docker --force
code --uninstall-extension ms-python.vscode-python-envs --force

rm -rf $XDG_DATA_HOME/typescript

# yazi

sudo pacman -S --noconfirm resvg

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

