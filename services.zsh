#!/usr/bin/env zsh

set -e -o verbose

# time sync

sudo timedatectl set-ntp true

# services

sudo systemctl enable fstrim.timer

sudo systemctl enable bluetooth.service
sudo systemctl enable avahi-daemon.service
sudo systemctl enable NetworkManager.service

systemctl --user enable pipewire-pulse.service

sudo systemctl enable gdm.service

sudo systemctl enable reflector.timer

sudo cp /etc/iptables/iptables.rules /etc/iptables/iptables.rules.backup
sudo cp `dirname $0`/etc/iptables/iptables.rules /etc/iptables/iptables.rules
sudo systemctl enable iptables.service

# sudo cp /etc/nftables.conf /etc/nftables.conf.backup
# sudo cp `dirname $0`/etc/nftables.rules /etc/nftables.rules
# sudo systemctl enable nftables.service

[[ -d ~/.config/systemd/user ]] || mkdir -p ~/.config/systemd/user

cp `dirname $0`/home/greg/.config/systemd/user/dnd.service ~/.config/systemd/user
systemctl --user enable dnd.service

cp `dirname $0`/home/greg/.config/systemd/user/sync-* ~/.config/systemd/user
systemctl --user enable sync-periodic.timer
systemctl --user enable sync-session.service

# if [[ $HOST = 'drifter' ]]; then

  # cp `dirname $0`/home/greg/.config/systemd/user/4k.service ~/.config/systemd/user
  # systemctl --user enable 4k.service

# fi

if [[ $HOST = 'player' || $HOST = 'worker' ]]; then

  sudo systemctl mask colord.service

  cp `dirname $0`/home/greg/.config/systemd/user/colors.service ~/.config/systemd/user
  systemctl --user enable colors.service

  cp `dirname $0`/home/greg/.config/systemd/user/imwheel.service ~/.config/systemd/user
  systemctl --user enable imwheel.service

fi

# group check

sudo grpck

