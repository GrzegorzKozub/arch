#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  jupyterlab

pip install --user --break-system-packages \
  jjava

paru -S --aur --noconfirm \
  quarto-cli-bin

# cleanup

. `dirname $0`/packages.zsh

