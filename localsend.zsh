#!/usr/bin/env zsh

set -e -o verbose

# packages

paru -S --aur --noconfirm \
  localsend-bin

# cleanup

`dirname $0`/packages.sh

# dotfiles

~/code/dot/localsend.zsh

