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
  EXEC=$(cat /usr/share/applications/$APP.desktop | grep '^Exec=')
  printf "[Desktop Entry]\n%s\nNoDisplay=true" $EXEC > ~/.local/share/applications/$APP.desktop
done

