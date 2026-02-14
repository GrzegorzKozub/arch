#!/usr/bin/env bash
set -eo pipefail -ux

# packages

sudo pacman -S --noconfirm \
  gimp

# links

cp /usr/share/applications/gimp.desktop "$XDG_DATA_HOME"/applications
sed -i -e 's/^Name=.*/Name=GIMP/' "$XDG_DATA_HOME"/applications/gimp.desktop

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
