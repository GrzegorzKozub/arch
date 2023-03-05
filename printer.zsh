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

LOCAL=${XDG_DATA_HOME:-~/.local/share}/applications

for APP in \
  cups \
  hplip \
  hp-uiscan
do
  cp /usr/share/applications/$APP.desktop $LOCAL
  sed -i '2iNoDisplay=true' $LOCAL/$APP.desktop
done

