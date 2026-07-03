#!/usr/bin/env bash
set -o pipefail -ux

# remove unused packages

# shellcheck disable=SC2046
ORPHANS=$(pacman -Qdtq) && sudo pacman --noconfirm -Rsn "$ORPHANS" || true

# workaround https://gitlab.archlinux.org/pacman/pacman/-/work_items/297

sudo rm -rf /var/cache/pacman/pkg/download-*

# clean package caches

sudo pacman --noconfirm -Sc # -Scc also removes INSTALLED packages from /var/cache/pacman/pkg
# yay --aur --noconfirm -Sc # -Scc also removes INSTALLED package clones from ~/.cache/yay
yes | paru --aur -Sccd

true
