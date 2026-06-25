#!/usr/bin/env bash
set -eo pipefail -ux

# packages

sudo pacman -S --noconfirm \
  jupyterlab

pip install --user --break-system-packages \
  jjava

yay --aur --noconfirm --answerdiff=None -S \
  quarto-cli-bin

# links

for APP in \
  ipython \
  jupyterlab; do
  cp /usr/share/applications/$APP.desktop "$XDG_DATA_HOME"/applications
  sed -i '2iNoDisplay=true' "$XDG_DATA_HOME"/applications/$APP.desktop
done

# cleanup

"${BASH_SOURCE%/*}"/packages.sh

# dotfiles

[[ -d $XDG_CONFIG_HOME/ipython ]] || mkdir "$XDG_CONFIG_HOME"/ipython
