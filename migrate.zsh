#!/usr/bin/env zsh

set -o verbose

sudo pacman -S --noconfirm \
  go-yq \
  silicon \
  zoxide

paru -S --aur --noconfirm \
  ttf-victor-mono

