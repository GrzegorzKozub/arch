#!/usr/bin/env zsh

set -e -o verbose

# drawing

sudo pacman -S --noconfirm \
  gimp

# sudo pacman -S --noconfirm \
  # drawing

# links

for APP in \
  gimp
do
  cp /usr/share/applications/$APP.desktop ~/.local/share/applications
  sed -i \
    -e 's/^Name=GNU Image Manipulation Program$/Name=GIMP/' \
    ~/.local/share/applications/$APP.desktop
done

