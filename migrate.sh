#!/usr/bin/env bash
set -eo pipefail -ux

# claude code sandbox bug: https://github.com/anthropics/claude-code/issues/17087
# shutdown bug: https://bbs.archlinux.org/viewtopic.php?pid=2278862

# ai

[[ $HOST =~ ^(drifter|worker)$ ]] && "${BASH_SOURCE%/*}"/claude.sh

# teams

if [[ $HOST =~ ^(drifter|worker)$ ]]; then
  sudo pacman -Rs teams-for-linux
  "${BASH_SOURCE%/*}"/teams.sh
fi

# tidal

paru -S --aur --noconfirm tidal-hifi-bin

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
