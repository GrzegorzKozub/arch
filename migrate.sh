#!/usr/bin/env bash
set -eo pipefail -ux

# shutdown bug: https://bbs.archlinux.org/viewtopic.php?pid=2278862

# docker & podman

sudo sed -i '/231072/d' /etc/subgid /etc/subuid
sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 "$USER"

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
