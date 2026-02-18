#!/usr/bin/env bash
set -eo pipefail -ux

# claude code sandbox bug: https://github.com/anthropics/claude-code/issues/17087
# shutdown bug: https://bbs.archlinux.org/viewtopic.php?pid=2278862

# teams

cp /usr/share/applications/teams-for-linux.desktop "$XDG_DATA_HOME"/applications
sed -i \
  -e 's/^Name=.*/Name=Teams/' \
  -e '/^Exec=/s/--gtk-version=3 //' \
  -e '/^Exec=/s/teams-for-linux/teams-for-linux --ozone-platform-hint=auto/' \
  "$XDG_DATA_HOME"/applications/teams-for-linux.desktop

# tidal

paru -S --aur --noconfirm tidal-hifi-bin

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
