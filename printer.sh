#!/usr/bin/env bash
set -eo pipefail -ux

# packages

sudo pacman -Sy --noconfirm \
  cups \
  system-config-printer

# services

sudo systemctl enable cups
sudo systemctl start cups

# links

cp /usr/share/applications/cups.desktop "$XDG_DATA_HOME"/applications
sed -i '2iNoDisplay=true' "$XDG_DATA_HOME"/applications/cups.desktop
