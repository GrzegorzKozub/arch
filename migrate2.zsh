#!/usr/bin/env zsh

set -o verbose

# node

paru -Rs --noconfirm \
  nvm

rm -rf $XDG_DATA_HOME/nvm

paru -S --aur --noconfirm \
  fnm-bin

