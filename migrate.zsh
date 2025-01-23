#!/usr/bin/env zsh

set -o verbose

# apsis

. `dirname $0`/apsis.zsh

# dust

rm -f ~/.config/dust
sudo pacman -Rs --noconfirm dust

# freerdp

sudo pacman -Rs --noconfirm freerdp

# mission-center

paru -S --aur --noconfirm \
  mission-center

# refine

paru -S --aur --noconfirm \
  refine

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

