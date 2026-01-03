#!/usr/bin/env zsh

set -e -o verbose

# packages

paru -S --aur --noconfirm \
  pinta

# cleanup

`dirname $0`/packages.zsh
