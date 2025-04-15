#!/usr/bin/env zsh

set -o verbose

# ghostty

sudo pacman -S --noconfirm ghostty

# vconsole

[[ $HOST = 'player' ]] &&
  sudo sed -i -e 's/216b/232b/' /etc/vconsole.conf

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

