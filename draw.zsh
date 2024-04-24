#!/usr/bin/env zsh

set -e -o verbose

# packages

paru -S --aur --noconfirm \
  drawio-desktop-bin

# links

cp /usr/share/applications/drawio.desktop $XDG_DATA_HOME/applications
sed -i '2iNoDisplay=true' $XDG_DATA_HOME/applications/drawio.desktop

cp /usr/share/applications/drawio.desktop $XDG_DATA_HOME/applications/draw.io.desktop
sed -i -e 's/^Name=.*/Name=draw.io/' $XDG_DATA_HOME/applications/draw.io.desktop

# file types

xdg-mime default draw.io.desktop application/vnd.jgraph.mxfile

