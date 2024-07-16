#!/usr/bin/env zsh

set -o verbose

# migrate

rm ~/.config/monitors.xml~
rm -rf ~/.config/flameshot

sudo pacman -Rs --noconfirm \
  flameshot

sudo pacman -S --noconfirm \
  qt5-wayland

[[ $HOST = 'worker' ]] && . `dirname $0`/apsis.zsh

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

