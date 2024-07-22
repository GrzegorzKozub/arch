#!/usr/bin/env zsh

set -o verbose

# migrate

paru -S --aur --noconfirm \
  gnome-shell-extension-rounded-window-corners-reborn

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

