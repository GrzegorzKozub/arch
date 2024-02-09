#!/usr/bin/env zsh

set -e -o verbose

# update self

git pull

# update all packages

sudo pacman --noconfirm -Sy archlinux-keyring

sudo pacman --noconfirm -Syu
paru --aur --noconfirm -Syu

paru -S --aur --noconfirm \
  neovim-nightly-bin

# merge *.pacnew and *.pacsave files

sudo DIFFPROG='nvim -d' pacdiff

# settings

. `dirname $0`/settings.zsh
. `dirname $0`/links.zsh
. `dirname $0`/gdm.zsh

[[ $XDG_CURRENT_DESKTOP = 'GNOME' ]] && . `dirname $0`/gnome.zsh
[[ $XDG_CURRENT_DESKTOP = 'KDE' ]] && . `dirname $0`/plasma.zsh

# cleanup

sudo journalctl --vacuum-time=3months

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

