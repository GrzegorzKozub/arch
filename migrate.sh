#!/usr/bin/env bash
set -eo pipefail -ux

# imv

sudo pacman -S --noconfirm imv

# pending migrations

if [[ $HOST =~ ^(drifter|player)$ ]]; then

  # fswatch
  sudo pacman -Syy
  sudo pacman -Rs --noconfirm fswatch
  sudo pacman -Sy --noconfirm fswatch

  # mcp
  claude mcp remove github || true

fi

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
