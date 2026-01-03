#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  jupyterlab

pip install --user --break-system-packages \
  jjava

paru -S --aur --noconfirm \
  quarto-cli-bin

# links

for APP in \
  ipython \
  jupyterlab
do
  cp /usr/share/applications/$APP.desktop $XDG_DATA_HOME/applications
  sed -i '2iNoDisplay=true' $XDG_DATA_HOME/applications/$APP.desktop
done

# cleanup

`dirname $0`/packages.zsh

# dotfiles

[[ -d $XDG_CONFIG_HOME/ipython ]] || mkdir $XDG_CONFIG_HOME/ipython
