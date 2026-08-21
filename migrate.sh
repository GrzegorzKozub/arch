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

  # linecast

  uv tool install linecast

  # mcp

  claude mcp remove github || true

  # satty -> tensaku

  rm -rf ~/.config/satty
  sudo pacman -Rs --noconfirm satty || true
  yay --aur --noconfirm --answerdiff=None -S tensaku-bin

fi

# fonts

[[ $HOST == 'player' ]] &&
  sudo pacman -S --noconfirm noto-fonts-emoji &&
  fc-cache -f

# fsmonitor

for DIR in ~/code/*/ ~/code/*/*/; do
  [[ -d $DIR/.git ]] || continue
  rm -rf "$DIR"/.git/fsmonitor--daemon "$DIR"/.git/fsmonitor--daemon.ipc
done

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
