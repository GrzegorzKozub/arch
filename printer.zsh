#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -Sy --noconfirm \
  cups \
  system-config-printer

# services

sudo systemctl enable cups
sudo systemctl start cups

# links

for APP in \
  cups
do
  cp /usr/share/applications/$APP.desktop $XDG_DATA_HOME/applications
  sed -i '2iNoDisplay=true' $XDG_DATA_HOME/applications/$APP.desktop
done

