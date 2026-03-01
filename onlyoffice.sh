#!/usr/bin/env bash
set -eo pipefail -ux

# packages

paru -S --aur --noconfirm \
  onlyoffice-bin

# flatpak --assumeyes install flathub com.github.tchx84.Flatseal
# flatpak --assumeyes install flathub org.onlyoffice.desktopeditors

# cleanup

"${BASH_SOURCE%/*}"/packages.sh

# dotfiles

~/code/dot/onlyoffice.sh
