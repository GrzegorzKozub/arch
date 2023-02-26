#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -Sy --noconfirm \
  cups \
  hplip \
  system-config-printer

# sudo pacman -Sy --noconfirm \
#   python-gobject python-pyqt5

# paru -S --aur --noconfirm \
#   hpuld

# services

sudo systemctl enable cups
sudo systemctl start cups

# links

for APP in \
  cups \
  hplip \
  hp-uiscan
do
  cp /usr/share/applications/$APP.desktop ~/.local/share/applications
  sed -i '2iNoDisplay=true' ~/.local/share/applications/$APP.desktop
done

