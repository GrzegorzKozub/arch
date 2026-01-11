#!/usr/bin/env bash
set -o pipefail -ux

# remove unused packages

sudo pacman --noconfirm -Rsn "$(pacman -Qdtq)"

# workaround https://forum.endeavouros.com/t/solved-latest-pacman-update-breaks-aur-and-yay/76959

sudo rm -rf /var/cache/pacman/pkg/download-*

# clean package caches

sudo pacman --noconfirm -Sc
yes | paru --aur -Sccd

true
