#!/usr/bin/env zsh

set -o verbose

# vconsole

[[ $HOST = 'player' ]] &&
  sudo sed -i -e 's/216b/232b/' /etc/vconsole.conf

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

