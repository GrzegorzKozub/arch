#!/usr/bin/env bash
set -eo pipefail -ux

# claude code sandbox bug: https://github.com/anthropics/claude-code/issues/17087
# shutdown bug: https://bbs.archlinux.org/viewtopic.php?pid=2278862

# sandboxing

sudo pacman -S --noconfirm bubblewrap socat

# tidal

[[ $HOST == 'worker' ]] && sudo rm -f /var/lib/systemd/coredump/*

cp /usr/share/applications/tidal-hifi.desktop "$XDG_DATA_HOME"/applications
sed -i \
  -e 's/^Exec=.*$/Exec=tidal-hifi --disable-seccomp-filter-sandbox %U/' \
  -e 's/^Name=.*$/Name=TIDAL/' \
  "$XDG_DATA_HOME"/applications/tidal-hifi.desktop

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
