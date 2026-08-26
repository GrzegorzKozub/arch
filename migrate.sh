#!/usr/bin/env bash
set -eo pipefail -ux

# claude

if [[ $HOST == 'worker' ]]; then
  for DIR in \
    ~/.claude \
    ~/.cache/claude \
    ~/.cache/claude-cli-nodejs \
    ~/.local/bin/claude \
    ~/.local/share/claude \
    ~/.local/state/claude; do
    rm -rf "$DIR"
  done

  pushd ~/code/dot && git pull && popd
  "${BASH_SOURCE%/*}"/claude.sh

fi

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

# tidal

pushd ~/code/dot
git update-index --no-assume-unchanged tidal-hifi/tidal-hifi/config.json
git pull
popd

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
