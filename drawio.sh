#!/usr/bin/env bash
set -eo pipefail -ux

# packages

yay --aur --noconfirm --answerdiff=None -S \
  drawio-desktop-bin

# links

cp /usr/share/applications/drawio-desktop.desktop "$XDG_DATA_HOME"/applications
sed -i \
  -e 's/^Name=.*/Name=draw.io/' \
  "$XDG_DATA_HOME"/applications/drawio-desktop.desktop

# default apps

xdg-mime default draw.io.desktop application/vnd.jgraph.mxfile

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
