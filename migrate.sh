#!/usr/bin/env bash
set -eo pipefail -ux

# shutdown bug: https://bbs.archlinux.org/viewtopic.php?pid=2278862

# hosts

[[ $HOST == 'worker' ]] && "${BASH_SOURCE%/*}"/hosts.zsh

# limine

sudo rm -f /etc/pacman.d/hooks/90-limine-update.hook
sudo cp "${BASH_SOURCE%/*}"/etc/pacman.d/hooks/91-limine.hook /etc/pacman.d/hooks/

# vscode

code --install-extension ms-vscode-remote.remote-containers --force

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
