#!/usr/bin/env zsh

set -e -o verbose

# update self

git pull

# update all packages

# sudo pacman --noconfirm -Sy archlinux-keyring

sudo pacman --noconfirm -Syu

paru --aur --noconfirm -Syu

set +e

paru -S --aur --noconfirm \
  neovim-nightly-bin \
  yazi-nightly-bin

set -e

# merge *.pacnew and *.pacsave files

sudo DIFFPROG='nvim -d' pacdiff

# settings

. `dirname $0`/settings.zsh
. `dirname $0`/links.zsh

zsh `dirname $0`/gdm.zsh

[[ $XDG_CURRENT_DESKTOP = 'GNOME' ]] && . `dirname $0`/gnome.zsh

. `dirname $0`/mime.zsh

. `dirname $0`/secrets.sh || true

# cleanup

sudo journalctl --vacuum-time=1months

. `dirname $0`/packages.zsh

