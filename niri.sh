#!/usr/bin/env bash
set -eo pipefail -ux

# packages - niri

sudo pacman -S --noconfirm \
  xdg-desktop-portal-gnome xdg-desktop-portal-gtk \
  niri

# packages - noctalia

sudo pacman -S --noconfirm \
  qt6-multimedia-ffmpeg \
  noctalia-shell

# dotfiles

~/code/dot/niri.sh
