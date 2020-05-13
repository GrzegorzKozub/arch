#!/usr/bin/env zsh

set -e -o verbose

# time sync

sudo timedatectl set-ntp true

# service autostart

sudo systemctl enable avahi-daemon.service
sudo systemctl enable gdm.service
sudo systemctl enable NetworkManager.service

[[ -d ~/.config/systemd/user ]] || mkdir -p ~/.config/systemd/user

if [[ $HOST = 'drifter' ]]; then

  sudo systemctl enable laptop-mode.service

  cp `dirname $0`/home/greg/.config/systemd/user/4k.service ~/.config/systemd/user
  systemctl --user enable 4k

fi

if [[ $HOST = 'turing' ]]; then

  cp `dirname $0`/home/greg/.config/systemd/user/imwheel.service ~/.config/systemd/user
  systemctl --user enable imwheel

fi

# group check

sudo grpck

