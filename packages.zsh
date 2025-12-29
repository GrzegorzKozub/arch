#!/usr/bin/env zsh

set -e -o verbose

# cleanup after teams-for-linux (disabled ad nodejs is required by zed)

# set +e
# sudo pacman -Rs --noconfirm \
#   node-gyp nodejs npm
# set -e

# remove unused packages

set +e
sudo pacman --noconfirm -Rsn $(pacman -Qdtq)
set -e

# workaround https://forum.endeavouros.com/t/solved-latest-pacman-update-breaks-aur-and-yay/76959

set +e
sudo rm -rf /var/cache/pacman/pkg/download-*
set -e

# clean package caches

sudo pacman --noconfirm -Sc
yes | paru --aur -Sccd

