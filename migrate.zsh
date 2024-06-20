#!/usr/bin/env zsh

set -o verbose

# migrate

# sudo pacman -S --noconfirm \
#   gopass
#
# sudo pacman -Rs --noconfirm \
#   cava
#
# paru -S --aur --noconfirm \
#   cava
#
# sudo pacman -S --noconfirm \
#   ffmpegthumbnailer \
#   ouch \
#   poppler \
#   yazi

if [[ $HOST = 'worker' ]]; then

  sudo sed -i -e '/.*aud-stage.*/d' /etc/hosts

  echo '127.0.0.1 int.aud-stage.apsis.cloud' | sudo tee --append /etc/hosts > /dev/null
  echo '::1       int.aud-stage.apsis.cloud' | sudo tee --append /etc/hosts > /dev/null

  echo '127.0.0.1 alb-int.aud-stage.apsis.cloud' | sudo tee --append /etc/hosts > /dev/null
  echo '::1       alb-int.aud-stage.apsis.cloud' | sudo tee --append /etc/hosts > /dev/null

  sudo sed -i -e '/.*stage\.ma.*/d' /etc/hosts

  echo '127.0.0.1 api.stage.ma' | sudo tee --append /etc/hosts > /dev/null
  echo '::1       api.stage.ma' | sudo tee --append /etc/hosts > /dev/null

  sudo sed -i -e '/.*dev\.apsis.*/d' /etc/hosts

  echo '127.0.0.1 dev.apsis' | sudo tee --append /etc/hosts > /dev/null
  echo '::1       dev.apsis' | sudo tee --append /etc/hosts > /dev/null

fi

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh
