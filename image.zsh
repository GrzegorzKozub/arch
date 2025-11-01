#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  gimp

paru -S --aur --noconfirm \
  pinta

# links

cp /usr/share/applications/gimp.desktop $XDG_DATA_HOME/applications
sed -i -e 's/^Name=.*/Name=GIMP/' $XDG_DATA_HOME/applications/gimp.desktop

# cleanup

. `dirname $0`/packages.zsh
