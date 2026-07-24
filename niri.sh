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
  elephant-bin \
  elephant-desktopapplications-bin \
  elephant-providerlist-bin \
  elephant-windows-bin

sudo pacman -S --noconfirm \
  walker

# hidden links

"${BASH_SOURCE%/*}"/nodisplay.sh

# dotfiles

~/code/dot/niri.sh

# config

for SVC in elephant walker; do
  cp "${BASH_SOURCE%/*}"/home/.config/systemd/user/"$SVC".service "$XDG_CONFIG_HOME"/systemd/user
  systemctl --user enable "$SVC".service
done
