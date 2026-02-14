#!/usr/bin/env bash
set -eo pipefail -ux

# packages

paru -S --aur --noconfirm \
  drawio-desktop-bin

# links

cp /usr/share/applications/drawio-desktop.desktop "$XDG_DATA_HOME"/applications
sed -i \
  -e 's/^Name=.*/Name=draw.io/' \
  -e 's/\/opt\/drawio-desktop\/drawio/\/opt\/drawio-desktop\/drawio --ozone-platform-hint=auto/' \
  "$XDG_DATA_HOME"/applications/drawio-desktop.desktop

# default apps

xdg-mime default draw.io.desktop application/vnd.jgraph.mxfile

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
