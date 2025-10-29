#!/usr/bin/env zsh

set -e -o verbose

# packages

paru -S --aur --noconfirm \
  microsoft-edge-stable-bin

# links

cp /usr/share/applications/microsoft-edge.desktop $XDG_DATA_HOME/applications
sed -i -e 's/^Name=.*/Name=Edge/' $XDG_DATA_HOME/applications/microsoft-edge.desktop

# cleanup

. `dirname $0`/packages.zsh

