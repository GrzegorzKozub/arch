#!/usr/bin/env bash

set -e -o verbose

# update self

pushd "${BASH_SOURCE%/*}" && git pull && popd

# update all packages

# sudo pacman --noconfirm -Sy archlinux-keyring
sudo pacman --noconfirm -Syu
paru --aur --noconfirm -Syu

set +e

paru -S --aur --noconfirm \
  yazi-nightly-bin

set -e

# merge *.pacnew and *.pacsave files

sudo DIFFPROG='nvim -d' pacdiff

# settings

"${BASH_SOURCE%/*}"/settings.zsh
"${BASH_SOURCE%/*}"/links.zsh

"${BASH_SOURCE%/*}"/gdm.zsh

[[ $XDG_CURRENT_DESKTOP == 'GNOME' ]] && "${BASH_SOURCE%/*}"/gnome.zsh

"${BASH_SOURCE%/*}"/mime.zsh
"${BASH_SOURCE%/*}"/secrets.sh

# cleanup

sudo journalctl --vacuum-time=1months

"${BASH_SOURCE%/*}"/packages.sh
