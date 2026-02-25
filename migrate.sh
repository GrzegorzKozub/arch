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

# sandboxing

sudo pacman -S --noconfirm bubblewrap socat

# tidal

paru -S --aur --noconfirm tidal-hifi-bin
pushd ~/code/dot/
git pull
git update-index --assume-unchanged tidal-hifi/tidal-hifi/config.json
./links.zsh
popd

cp /usr/share/applications/tidal-hifi.desktop "$XDG_DATA_HOME"/applications
sed -i \
  -e 's/^Exec=.*$/Exec=tidal-hifi --disable-seccomp-filter-sandbox %U/' \
  -e 's/^Name=.*$/Name=TIDAL/' \
  "$XDG_DATA_HOME"/applications/tidal-hifi.desktop

# [[ $HOST == 'worker' ]] && sudo rm -f /var/lib/systemd/coredump/*

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
