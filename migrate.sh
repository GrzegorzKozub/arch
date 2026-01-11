#!/usr/bin/env bash

set -o verbose

# shutdown bug: https://bbs.archlinux.org/viewtopic.php?pid=2278862

# hosts

[[ $HOST == 'worker' ]] && "${BASH_SOURCE%/*}"/hosts.zsh

# limine

sudo rm -f /etc/pacman.d/hooks/90-limine-update.hook
sudo cp "${BASH_SOURCE%/*}"/etc/pacman.d/hooks/91-limine.hook /etc/pacman.d/hooks/

# cleanup

"${BASH_SOURCE%/*}"/packages.zsh
"${BASH_SOURCE%/*}"/clean.zsh
