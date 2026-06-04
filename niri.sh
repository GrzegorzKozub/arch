#!/usr/bin/env bash
set -eo pipefail -ux

# packages - niri

sudo pacman -S --noconfirm \
  xdg-desktop-portal-gnome xdg-desktop-portal-gtk \
  gnome-keyring \
  niri

# packages - noctalia

sudo pacman -S --noconfirm \
  qt6-multimedia-ffmpeg \
  noctalia-shell \
  wlsunset

# dotfiles

~/code/dot/niri.sh
