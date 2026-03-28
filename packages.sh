#!/usr/bin/env bash
set -o pipefail -ux

# remove unused packages

# shellcheck disable=SC2046
sudo pacman --noconfirm -Rsn $(pacman -Qdtq)

# workaround https://gitlab.archlinux.org/pacman/pacman/-/work_items/297

sudo rm -rf /var/cache/pacman/pkg/download-*

# clean package caches

sudo pacman --noconfirm -Sc
yes | paru --aur -Sccd

true
