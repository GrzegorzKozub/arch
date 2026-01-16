#!/usr/bin/env bash
set -o pipefail -ux

# packages

sudo pacman -S --noconfirm \
  guvcview

# links

cp /usr/share/applications/guvcview.desktop "$XDG_DATA_HOME"/applications
sed -i -e 's/^_Name=/Name=/' "$XDG_DATA_HOME"/applications/guvcview.desktop

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
