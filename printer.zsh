#!/usr/bin/env zsh

set -e -o verbose

# printer

sudo pacman -Sy --noconfirm \
  cups \
  hplip \
  nss-mdns \
  system-config-printer

sudo systemctl enable org.cups.cupsd.service
sudo systemctl start org.cups.cupsd.service

sudo systemctl enable avahi-daemon.service
sudo systemctl start avahi-daemon.service

sudo sed -i 's/myhostname resolve/myhostname mdns_minimal [NOTFOUND=return] resolve/' /etc/nsswitch.conf

for APP in \
  cups \
  hplip \
  hp-uiscan
do
  printf "[Desktop Entry]\nNoDisplay=true" > ~/.local/share/applications/$APP.desktop
done

