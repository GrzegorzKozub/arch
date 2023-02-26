#!/usr/bin/env zsh

set -e -o verbose

# packages

paru -S --aur --noconfirm \
  azuredatastudio-bin

# dotfiles

. ~/code/dotfiles/mssql.zsh

