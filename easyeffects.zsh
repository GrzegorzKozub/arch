#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  jalv lsp-plugins-lv2 \
  easyeffects

# links

for APP in \
  jalv \
  lstopo
do
  cp /usr/share/applications/$APP.desktop $XDG_DATA_HOME/applications
  sed -i '2iNoDisplay=true' $XDG_DATA_HOME/applications/$APP.desktop
done

# cleanup

`dirname $0`/packages.zsh
