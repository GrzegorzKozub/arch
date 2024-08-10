#!/usr/bin/env zsh

set -e -o verbose

# cleanup after teams-for-linux

sudo pacman -Rs --noconfirm \
  node-gyp nodejs npm

# remove unused packages

set +e
sudo pacman --noconfirm -Rsn $(pacman -Qdtq)
set -e

# clean package caches

sudo pacman --noconfirm -Sc
yes | paru --aur -Sccd

