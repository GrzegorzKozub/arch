#!/usr/bin/env bash
set -eo pipefail -ux

# prep

sudo pacman -Sy && pushd ~/code/dot && git pull && ./repos.sh && popd

# auth0

[[ $HOST == 'worker' ]] && "${BASH_SOURCE%/*}"/auth0.sh

# claude

"${BASH_SOURCE%/*}"/claude.sh

# snaps

"${BASH_SOURCE%/*}"/data.sh
"${BASH_SOURCE%/*}"/secrets.sh

cp "${BASH_SOURCE%/*}"/home/.config/systemd/user/snap.* "$XDG_CONFIG_HOME"/systemd/user
systemctl --user enable snap.timer

# ssh

rm -rf ~/.ssh/known_hosts.old

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
