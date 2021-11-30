#!/usr/bin/env zsh

set -e -o verbose

# picture

sudo pacman -S --noconfirm \
  gimp

# links

for APP in \
  gimp
do
  cp /usr/share/applications/$APP.desktop ~/.local/share/applications
  sed -i \
    -e 's/^Name=GNU Image Manipulation Program$/Name=GIMP/' \
    ~/.local/share/applications/$APP.desktop
done
