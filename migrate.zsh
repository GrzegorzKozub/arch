#!/usr/bin/env zsh

set -o verbose

# secure boot

paru -Rs --aur --noconfirm \
  preloader-signed

sudo pacman -S --noconfirm \
  sbctl

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

