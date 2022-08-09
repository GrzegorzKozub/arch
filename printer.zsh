#!/usr/bin/env zsh

set -e -o verbose

# printer

sudo pacman -Sy --noconfirm \
  cups

paru -S --aur --noconfirm \
  hpuld

# sudo pacman -Sy --noconfirm \
  # system-config-printer \
  # hplip hplip-plugin python-gobject python-pyqt5

sudo systemctl enable cups
sudo systemctl start cups

# links

for APP in \
  cups \
  # hplip \
  # hp-uiscan
do
  printf "[Desktop Entry]\nNoDisplay=true" > ~/.local/share/applications/$APP.desktop
done

