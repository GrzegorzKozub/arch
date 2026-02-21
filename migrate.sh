#!/usr/bin/env bash
set -eo pipefail -ux

# claude code sandbox bug: https://github.com/anthropics/claude-code/issues/17087
# shutdown bug: https://bbs.archlinux.org/viewtopic.php?pid=2278862

# ai

[[ $HOST == 'worker' ]] && "${BASH_SOURCE%/*}"/claude.sh

# teams

if [[ $HOST =~ ^(drifter|worker)$ ]]; then
  sudo pacman -Rs --noconfirm teams-for-linux || true
  "${BASH_SOURCE%/*}"/teams.sh
fi

# tidal

paru -S --aur --noconfirm tidal-hifi-bin
pushd ~/code/dot/
git update-index --assume-unchanged tidal-hifi/tidal-hifi/config.json
./links.zsh
popd

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
