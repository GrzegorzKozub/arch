#!/usr/bin/env zsh

set -e -o verbose

# picture

sudo pacman -S --noconfirm \
  gimp

# links

APP=gimp
cp /usr/share/applications/$APP.desktop ~/.local/share/applications
sed -i \
  -e 's/^Name=.*$/Name=GIMP/' \
  ~/.local/share/applications/$APP.desktop

