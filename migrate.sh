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

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
