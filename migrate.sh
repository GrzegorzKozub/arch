#!/usr/bin/env bash
set -eo pipefail -ux

# airplane mode

rfkill unblock all
"${BASH_SOURCE%/*}"/settings.sh

# gnome

sudo pacman -Rs --noconfirm gnome-system-monitor

# dconf dump /org/gnome/
dconf reset -f /org/gnome/gnome-system-monitor/

# locale

sudo locale-gen

# pacman -> yay

pushd ~/code/dot
git pull && git submodule foreach --recursive git pull
./links.sh
popd

"${BASH_SOURCE%/*}"/yay.sh

yay --aur --noconfirm -Rs paru || true
rm -rf ~/.cache/paru
rm -rf ~/.local/state/paru

yay --aur --noconfirm --answerdiff=None -S tmux-git

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
