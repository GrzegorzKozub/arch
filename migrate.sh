#!/usr/bin/env bash
set -eo pipefail -ux

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

systemctl --user daemon-reload
systemctl --user enable dnd.service wall.timer

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
