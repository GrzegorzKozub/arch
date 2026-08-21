#!/usr/bin/env bash
set -eo pipefail -ux

# pending migrations

if [[ $HOST == 'drifter' ]]; then

  # fswatch

  sudo pacman -Syy
  sudo pacman -Rs --noconfirm fswatch
  sudo pacman -Sy --noconfirm fswatch

  # imv

  sudo pacman -S --noconfirm imv

  # mcp

  claude mcp remove github || true

fi

if [[ $HOST =~ ^(drifter|player)$ ]]; then

  # linecast

  uv tool install linecast

  # satty -> tensaku

  rm -rf ~/.config/satty
  sudo pacman -Rs --noconfirm satty || true
  yay --aur --noconfirm --answerdiff=None -S tensaku-bin

fi

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
