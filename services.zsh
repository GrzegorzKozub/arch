#!/usr/bin/env zsh

set -e -o verbose

# time sync

sudo timedatectl set-ntp true

# service autostart

sudo systemctl enable avahi-daemon.service
sudo systemctl enable gdm.service
sudo systemctl enable NetworkManager.service

if [[ $HOST = 'drifter' ]]; then

  sudo systemctl enable laptop-mode.service

fi

if [[ $HOST = 'turing' ]]; then

  [[ -d ~/.config/systemd/user ]] || mkdir -p ~/.config/systemd/user
  cp `dirname $0`/home/greg/.config/systemd/user/imwheel.service ~/.config/systemd/user
  systemctl --user enable imwheel

fi

# group check

sudo grpck

