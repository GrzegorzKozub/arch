#!/usr/bin/env zsh

set -o verbose

# migrate

sudo pacman -S --noconfirm \
  gopass

sudo pacman -Rs --noconfirm \
  cava

paru -S --aur --noconfirm \
  cava

sudo pacman -S --noconfirm \
  ffmpegthumbnailer \
  ouch \
  poppler \
  yazi

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh
