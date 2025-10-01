#!/usr/bin/env zsh

set -o verbose

# gnome

rm -rf $XDG_DATA_HOME/gnome-shell/extensions/panel@grzegorzkozub.github.com

gsettings reset org.gnome.shell enabled-extensions

for NAME ('blur-my-shell@aunetx' 'rounded-window-corners@fxgn' 'windows@grzegorzkozub.github.com')
  gnome-extensions enable $NAME

# heic

sudo pacman -S --noconfirm libheif

# keyring

secret-tool clear app_id ""
secret-tool clear app_id brave-browser
secret-tool clear app_id org.chromium.Chromium
secret-tool clear application Slack

# python

rm -rf $XDG_DATA_HOME/doc
rm -rf $XDG_DATA_HOME/jupyter

# qt

sudo pacman -S --noconfirm qt6-wayland

# settings

[[ $HOST = 'drifter' ]] && sudo pacman -S --noconfirm brightnessctl && brightnessctl set 25%

# screenshot

sudo pacman -Rs --noconfirm gnome-screenshot
rm -rf $XDG_DATA_HOME/applications/org.gnome.Screenshot.desktop

# vscode

code --uninstall-extension ms-azuretools.vscode-docker --force
code --uninstall-extension ms-python.vscode-python-envs --force

rm -rf $XDG_CACHE_HOME/typescript

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

