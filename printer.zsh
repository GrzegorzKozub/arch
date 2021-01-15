#!/usr/bin/env zsh

set -e -o verbose

# printer

sudo pacman -Sy --noconfirm \
  cups \
  hplip \
  system-config-printer

sudo systemctl enable cups
sudo systemctl start cups

for APP in \
  cups \
  hplip \
  hp-uiscan
do
  printf "[Desktop Entry]\nNoDisplay=true" > ~/.local/share/applications/$APP.desktop
done

