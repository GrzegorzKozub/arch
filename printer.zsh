#!/usr/bin/env zsh

set -e -o verbose

# printer

sudo pacman -Sy --noconfirm \
  cups \
  system-config-printer

paru -S --aur --noconfirm \
  hpuld

# sudo pacman -Sy --noconfirm \
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

