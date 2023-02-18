#!/usr/bin/env zsh

set -e -o verbose

# mssql

paru -S --aur --noconfirm \
  azuredatastudio-bin

# dotfiles

. ~/code/dotfiles/mssql.zsh

