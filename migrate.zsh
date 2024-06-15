#!/usr/bin/env zsh

set -o verbose

sudo pacman -S --noconfirm \
  gopass

sudo pacman -Rs --noconfirm \
  cava

paru -S --aur --noconfirm \
  cava \

