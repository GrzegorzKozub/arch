#!/bin/sh

export QT_AUTO_SCREEN_SCALE_FACTOR=0
# export QT_QPA_PLATFORMTHEME=gtk2

if
  [[ $HOSTNAME = 'turing' || $HOSTNAME = 'pascal' ]] ||
  [[ $(systemctl --user is-active 4k.service) = 'active' ]]
then
  export QT_SCREEN_SCALE_FACTORS=1
  export QT_SCALE_FACTOR=1
elif [[ $HOSTNAME = 'drifter' ]]; then
  export QT_SCREEN_SCALE_FACTORS=2
  export QT_SCALE_FACTOR=0.9
fi

$1
