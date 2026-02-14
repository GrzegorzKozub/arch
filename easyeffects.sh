#!/usr/bin/env bash
set -eo pipefail -ux

# packages

sudo pacman -S --noconfirm \
  jalv lsp-plugins-lv2 \
  easyeffects

# links

for APP in \
  jalv \
   lstopo; do
  cp /usr/share/applications/$APP.desktop "$XDG_DATA_HOME"/applications
  sed -i '2iNoDisplay=true' "$XDG_DATA_HOME"/applications/$APP.desktop
done

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
