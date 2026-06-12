#!/usr/bin/env bash
set -o pipefail -ux

# remove unused packages

# shellcheck disable=SC2046
ORPHANS=$(pacman -Qdtq) && sudo pacman --noconfirm -Rsn "$ORPHANS" || true

# workaround https://gitlab.archlinux.org/pacman/pacman/-/work_items/297

sudo rm -rf /var/cache/pacman/pkg/download-*

# clean package caches

sudo pacman --noconfirm -Sc
yes | paru --aur -Sccd

true
