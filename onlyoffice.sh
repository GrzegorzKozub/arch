#!/usr/bin/env bash
set -eo pipefail -ux

# packages

# aur not needed on cachy
sudo pacman -S --noconfirm \
  onlyoffice-bin

# flatpak --assumeyes install flathub com.github.tchx84.Flatseal
# flatpak --assumeyes install flathub org.onlyoffice.desktopeditors

# cleanup

"${BASH_SOURCE%/*}"/packages.sh

# dotfiles

~/code/dot/onlyoffice.sh
