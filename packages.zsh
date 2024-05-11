#!/usr/bin/env zsh

set -e -o verbose

# remove unused packages

set +e
sudo pacman --noconfirm -Rsn $(pacman -Qdtq)
set -e

sudo pacman -Rs npm # clenup after gnome-shell-extension-rounded-window-corners-reborn-git

# clean package caches

sudo pacman --noconfirm -Sc
yes | paru --aur -Sccd

