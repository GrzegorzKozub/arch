#!/usr/bin/env bash
set -eo pipefail -ux

# pending migrations

if [[ $HOST == 'drifter' ]]; then

  # fswatch

  sudo pacman -Syy
  sudo pacman -Rs --noconfirm fswatch
  sudo pacman -Sy --noconfirm fswatch

  # mcp

  claude mcp remove github || true

fi

# imv

[[ $HOST =~ ^(drifter|worker)$ ]] && sudo pacman -S --noconfirm imv

# postman

if [[ $HOST == 'worker' ]]; then

  cp /usr/share/applications/postman.desktop "$XDG_DATA_HOME"/applications
  sed -i \
    -e 's/\/opt\/postman\/Postman/\/opt\/postman\/Postman --ozone-platform-hint=auto --disable-gpu-sandbox/' \
    "$XDG_DATA_HOME"/applications/postman.desktop

fi

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
