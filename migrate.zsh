#!/usr/bin/env zsh

set -o verbose

# migrate

sudo pacman --noconfirm -Syu

sudo pacman -S --noconfirm \
  glib2-devel

sudo pacman -S --noconfirm \
  gopass

sudo pacman -Rs --noconfirm \
  cava

paru -S --aur --noconfirm \
  cava

sudo pacman -S --noconfirm \
  ffmpegthumbnailer \
  imagemagick \
  ouch \
  yazi

sudo sed -i -e '/.*local.*/d' /etc/hosts

echo '127.0.0.1 localhost' | sudo tee --append /etc/hosts > /dev/null
echo '::1       localhost' | sudo tee --append /etc/hosts > /dev/null

echo '127.0.0.1 player.localdomain player' | sudo tee --append /etc/hosts > /dev/null
echo '::1       player.localdomain player' | sudo tee --append /etc/hosts > /dev/null

. `dirname $0`/apsis.zsh

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

