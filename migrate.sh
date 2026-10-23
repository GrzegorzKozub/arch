#!/usr/bin/env bash
set -eo pipefail -ux

# prep

pushd "${BASH_SOURCE%/*}" && git pull && popd
pushd ~/code/dot && git pull && ./repos.sh && popd
sudo pacman -Sy

# keepassxc

rm -rf "$XDG_DATA_HOME"/applications/org.keepassxc.KeePassXC.desktop

# mise

~/code/dot/reset.sh mise

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
