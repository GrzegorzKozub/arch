#!/usr/bin/env bash
set -eo pipefail -ux

# https://www.phoronix.com/news/Realtek-RTL8159-Linux-7.2
# https://aur.archlinux.org/packages/r8152-dkms

sudo pacman -S --noconfirm \
  linux-headers

paru -S --aur --noconfirm \
  r8152-dkms
