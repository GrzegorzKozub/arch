#!/usr/bin/env bash
set -eo pipefail -ux

# packages - niri

sudo pacman -S --noconfirm \
  xdg-desktop-portal-gnome xdg-desktop-portal-gtk \
  gnome-keyring \
  niri

# packages - noctalia

sudo pacman -S --noconfirm \
  noctalia

  # wlsunset

# hidden links

"${BASH_SOURCE%/*}"/nodisplay.sh

# dotfiles

~/code/dot/niri.sh
