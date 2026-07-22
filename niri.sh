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

# packages - walker & elephant

yay --aur --noconfirm --answerdiff=None -S \
  elephant-bin elephant-providerlist-bin \
  elephant-desktopapplications-bin \
  elephant-files-bin \
  elephant-runner-bin

sudo pacman -S --noconfirm \
  walker

# hidden links

"${BASH_SOURCE%/*}"/nodisplay.sh

# dotfiles

~/code/dot/niri.sh

# config

elephant service enable

# TODO
# mkdir -p ~/.config/systemd/user/niri.service.wants
# ln -s ~/.config/systemd/user/elephant.service ~/.config/systemd/user/niri.service.wants/elephant.service
