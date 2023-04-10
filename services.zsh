#!/usr/bin/env zsh

set -e -o verbose

# env

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-~/.config}

# time sync

sudo timedatectl set-ntp true

# services

sudo systemctl enable fstrim.timer

sudo systemctl enable bluetooth.service
sudo systemctl enable avahi-daemon.service
sudo systemctl enable NetworkManager.service

systemctl --user enable pipewire-pulse.service

sudo systemctl enable gdm.service

sudo systemctl enable pkgfile-update.timer
sudo systemctl enable reflector.timer

sudo cp /etc/iptables/iptables.rules /etc/iptables/iptables.rules.backup
sudo cp `dirname $0`/etc/iptables/iptables.rules /etc/iptables/iptables.rules
sudo systemctl enable iptables.service

sudo cp /etc/iptables/ip6tables.rules /etc/iptables/ip6tables.rules.backup
sudo cp `dirname $0`/etc/iptables/ip6tables.rules /etc/iptables/ip6tables.rules
sudo systemctl enable ip6tables.service

# sudo cp /etc/nftables.conf /etc/nftables.conf.backup
# sudo cp `dirname $0`/etc/nftables.rules /etc/nftables.rules
# sudo systemctl enable nftables.service

[[ -d $XDG_CONFIG_HOME/systemd/user ]] || mkdir -p $XDG_CONFIG_HOME/systemd/user

cp `dirname $0`/home/$USER/.config/systemd/user/sync-* $XDG_CONFIG_HOME/systemd/user
systemctl --user enable sync-periodic.timer
systemctl --user enable sync-session.service

if [[ $HOST = 'player' || $HOST = 'worker' ]]; then

  # conflicts with setting custom color profiles using dispwin
  sudo systemctl mask colord.service

  cp `dirname $0`/home/$USER/.config/systemd/user/redshift.service $XDG_CONFIG_HOME/systemd/user
  systemctl --user enable redshift.service

  cp `dirname $0`/home/$USER/.config/systemd/user/colors.service $XDG_CONFIG_HOME/systemd/user
  systemctl --user enable colors.service

  # cp `dirname $0`/home/$USER/.config/systemd/user/imwheel.service $XDG_CONFIG_HOME/systemd/user
  # systemctl --user enable imwheel.service

fi

if [[ $XDG_CURRENT_DESKTOP = 'GNOME' ]]; then

  cp `dirname $0`/home/$USER/.config/systemd/user/dnd.service $XDG_CONFIG_HOME/systemd/user
  systemctl --user enable dnd.service

fi

# group check

sudo grpck

