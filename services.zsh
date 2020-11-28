#!/usr/bin/env zsh

set -e -o verbose

# time sync

sudo timedatectl set-ntp true

# services

sudo systemctl enable avahi-daemon.service
sudo systemctl enable gdm.service
sudo systemctl enable NetworkManager.service

[[ -d ~/.config/systemd/user ]] || mkdir -p ~/.config/systemd/user

cp `dirname $0`/home/greg/.config/systemd/user/dnd.service ~/.config/systemd/user
systemctl --user enable dnd.service

cp `dirname $0`/home/greg/.config/systemd/user/code.* ~/.config/systemd/user
systemctl --user enable code.timer
systemctl --user start code.timer

cp `dirname $0`/home/greg/.config/systemd/user/history.* ~/.config/systemd/user
systemctl --user enable history.timer
systemctl --user start history.timer

cp `dirname $0`/home/greg/.config/systemd/user/passwords.* ~/.config/systemd/user
systemctl --user enable passwords.timer
systemctl --user start passwords.timer

if [[ $HOST = 'drifter' ]]; then

  # sudo systemctl enable bluetooth.service
  sudo systemctl enable laptop-mode.service

  cp `dirname $0`/home/greg/.config/systemd/user/4k.service ~/.config/systemd/user
  systemctl --user enable 4k.service

fi

if [[ $HOST = 'turing' ]]; then

  cp `dirname $0`/home/greg/.config/systemd/user/imwheel.service ~/.config/systemd/user
  systemctl --user enable imwheel.service

fi

# group check

sudo grpck

