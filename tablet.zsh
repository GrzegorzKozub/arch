#!/usr/bin/env zsh

set -e -o verbose

# tablet

paru -S --aur --noconfirm \
  xp-pen-tablet

sudo pacman -S --noconfirm \
  mypaint

# links

for APP in \
  Pentablet-Driver
do
  printf "[Desktop Entry]\nNoDisplay=true" > ~/.local/share/applications/$APP.desktop
done

