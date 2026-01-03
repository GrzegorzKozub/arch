#!/usr/bin/env bash

set -e -o verbose
HERE="${BASH_SOURCE%/*}"

# update self

pushd "$HERE" && git pull && popd

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

"$HERE"/settings.zsh
"$HERE"/links.zsh

"$HERE"/gdm.zsh

[[ $XDG_CURRENT_DESKTOP == 'GNOME' ]] && "$HERE"/gnome.zsh

"$HERE"/mime.zsh
"$HERE"/secrets.sh

# cleanup

sudo journalctl --vacuum-time=1months

"$HERE"/packages.zsh
