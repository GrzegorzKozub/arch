#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  inkscape

# cleanup

`dirname $0`/packages.sh
