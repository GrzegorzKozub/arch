#!/usr/bin/env zsh

set -o verbose

# firmware

if [[ $HOST = 'player' ]]; then
  sudo pacman -S --noconfirm linux-firmware-qlogic
  paru -S --aur --noconfirm ast-firmware
fi

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

