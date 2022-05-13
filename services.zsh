#!/usr/bin/env zsh

set -e -o verbose

# time sync

sudo timedatectl set-ntp true

# services

sudo systemctl enable fstrim.timer

sudo systemctl enable bluetooth.service
sudo systemctl enable avahi-daemon.service
sudo systemctl enable NetworkManager.service

sudo systemctl enable gdm.service

sudo systemctl enable reflector.timer

sudo cp `dirname $0`/etc/iptables/iptables.rules /etc/iptables/iptables.rules
sudo systemctl enable iptables.service

[[ -d ~/.config/systemd/user ]] || mkdir -p ~/.config/systemd/user

cp `dirname $0`/home/greg/.config/systemd/user/dnd.service ~/.config/systemd/user
systemctl --user enable dnd.service

cp `dirname $0`/home/greg/.config/systemd/user/net.service ~/.config/systemd/user
systemctl --user enable net.service

cp `dirname $0`/home/greg/.config/systemd/user/history.* ~/.config/systemd/user
systemctl --user enable history.timer
systemctl --user start history.timer

cp `dirname $0`/home/greg/.config/systemd/user/passwords.* ~/.config/systemd/user
systemctl --user enable passwords.timer
systemctl --user start passwords.timer

if [[ $HOST = 'drifter' ]]; then

  cp `dirname $0`/home/greg/.config/systemd/user/4k.service ~/.config/systemd/user
  systemctl --user enable 4k.service

fi

if [[ $HOST = 'player' || $HOST = 'worker' ]]; then
  cp `dirname $0`/home/greg/.config/systemd/user/imwheel.service ~/.config/systemd/user
  systemctl --user enable imwheel.service
fi

# group check

sudo grpck

