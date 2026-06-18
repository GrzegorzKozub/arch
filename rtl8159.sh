#!/usr/bin/env bash
set -eo pipefail -ux

# https://www.phoronix.com/news/Realtek-RTL8159-Linux-7.2
# https://aur.archlinux.org/packages/r8152-dkms

sudo pacman -S --noconfirm \
  linux-headers \
  linux-cachyos-headers

paru -S --aur \
  r8152-dkms
