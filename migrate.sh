#!/usr/bin/env bash
set -eo pipefail -ux

# fonts

[[ $HOST == 'player' ]] &&
  sudo pacman -S --noconfirm noto-fonts-emoji &&
  fc-cache -f

# fsmonitor

if [[ $HOST =~ ^(player|worker)$ ]]; then

  for DIR in ~/code/*/ ~/code/*/*/; do
    [[ -d $DIR/.git ]] || continue
    rm -rf "$DIR"/.git/fsmonitor--daemon "$DIR"/.git/fsmonitor--daemon.ipc
  done

fi

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
