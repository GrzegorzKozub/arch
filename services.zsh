#!/usr/bin/env zsh

set -e -o verbose

# time sync

sudo timedatectl set-ntp true

# service autostart

sudo systemctl enable gdm.service
sudo systemctl enable NetworkManager.service
if [[ $HOST = 'drifter' ]]; then
  sudo systemctl enable laptop-mode.service
fi

# group check

sudo grpck

