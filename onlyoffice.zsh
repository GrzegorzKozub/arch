#!/usr/bin/env zsh

set -e -o verbose

# packages

paru -S --aur --noconfirm \
  onlyoffice-bin

# flatpak --assumeyes install flathub com.github.tchx84.Flatseal
# flatpak --assumeyes install flathub org.onlyoffice.desktopeditors

# cleanup

. `dirname $0`/packages.zsh
