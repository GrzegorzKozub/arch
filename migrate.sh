#!/usr/bin/env bash
set -eo pipefail -ux

# hosts

if [[ $HOST == 'worker' ]]; then

  LIST=(
    int.email-stage.apsis.cloud
    int.folders-stage.apsis.cloud
  )

  for ITEM in "${LIST[@]}"; do
    sudo sed -i -e "/.*$ITEM.*/d" /etc/hosts
  done

fi

# brightness

if [[ $HOST == 'drifter' ]]; then

  sudo systemctl disable brightness.service
  sudo rm -f /etc/systemd/system/brightness.service

  systemctl --user disable brightness.service
  rm -f "$XDG_CONFIG_HOME"/systemd/user/brightness.service

fi

# gnome

dconf reset -f /org/gnome/Characters/
sudo pacman -Rs --noconfirm gnome-characters gnome-font-viewer || true

# services

systemctl --user disable dnd.service wall.timer

cp "${BASH_SOURCE%/*}"/home/.config/systemd/user/dnd.service "$XDG_CONFIG_HOME"/systemd/user
cp "${BASH_SOURCE%/*}"/home/.config/systemd/user/wall.timer "$XDG_CONFIG_HOME"/systemd/user

systemctl --user enable dnd.service wall.timer

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
