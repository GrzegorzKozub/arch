#!/usr/bin/env zsh

set -e -o verbose

# printer

sudo pacman -Sy --noconfirm \
  cups \
  hplip \
  system-config-printer

# sudo pacman -Sy --noconfirm \
  # python-gobject python-pyqt5

# paru -S --aur --noconfirm \
  # hpuld

sudo systemctl enable cups
sudo systemctl start cups

# links

for APP in \
  cups \
  hplip \
  hp-uiscan
do
  printf "[Desktop Entry]\nNoDisplay=true" > ~/.local/share/applications/$APP.desktop
done

