#!/usr/bin/env zsh

set -e -o verbose

# env

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-~/.config}

# time sync

sudo timedatectl set-ntp true

# system services

sudo systemctl enable fstrim.timer

sudo systemctl enable avahi-daemon.service
sudo systemctl enable NetworkManager.service

sudo systemctl enable bluetooth.service

systemctl --user enable pipewire-pulse.service

sudo systemctl enable gdm.service

sudo systemctl enable pkgfile-update.timer
sudo systemctl enable reflector.timer

# firewall

sudo cp /etc/iptables/iptables.rules /etc/iptables/iptables.rules.backup
sudo cp `dirname $0`/etc/iptables/iptables.rules /etc/iptables/iptables.rules
sudo systemctl enable iptables.service

sudo cp /etc/iptables/ip6tables.rules /etc/iptables/ip6tables.rules.backup
sudo cp `dirname $0`/etc/iptables/ip6tables.rules /etc/iptables/ip6tables.rules
sudo systemctl enable ip6tables.service

# sudo cp /etc/nftables.conf /etc/nftables.conf.backup
# sudo cp `dirname $0`/etc/nftables.rules /etc/nftables.rules
# sudo systemctl enable nftables.service

# dirs

[[ -d $XDG_CONFIG_HOME/systemd/user ]] || mkdir -p $XDG_CONFIG_HOME/systemd/user

# imwheel

# if [[ $HOST = 'player' || $HOST = 'worker' ]]; then
#
#   cp `dirname $0`/home/$USER/.config/systemd/user/imwheel.service $XDG_CONFIG_HOME/systemd/user
#   systemctl --user enable imwheel.service
#
# fi

# sync

cp `dirname $0`/home/$USER/.config/systemd/user/sync-* $XDG_CONFIG_HOME/systemd/user
systemctl --user enable sync-periodic.timer
systemctl --user enable sync-session.service

# night light

if [[ $HOST = 'player' ]]; then

  # conflicts with setting custom color profiles using dispwin
  sudo systemctl mask colord.service

  cp `dirname $0`/home/$USER/.config/systemd/user/colors.service $XDG_CONFIG_HOME/systemd/user
  systemctl --user enable colors.service

  cp `dirname $0`/home/$USER/.config/systemd/user/redshift.service $XDG_CONFIG_HOME/systemd/user
  systemctl --user enable redshift.service

fi

# amd gpu fan speed

if [[ $HOST = 'worker' ]]; then

  [[ -d /etc/amdfand ]] || sudo mkdir /etc/amdfand
  sudo cp `dirname $0`/etc/amdfand/config.toml /etc/amdfand/config.toml
  sudo systemctl enable amdfand.service

fi

# # wayland enabled on nvidia
#
# if [[ $HOST = 'player' ]]; then
#
#   # preserves nvidia video memory during suspend
#   sudo systemctl enable nvidia-hibernate.service
#   sudo systemctl enable nvidia-suspend.service
#
# fi

# do not disturb

if [[ $XDG_CURRENT_DESKTOP = 'GNOME' ]]; then

  cp `dirname $0`/home/$USER/.config/systemd/user/dnd.service $XDG_CONFIG_HOME/systemd/user
  systemctl --user enable dnd.service

fi

# random wallpaper every hour

cp `dirname $0`/home/$USER/.config/systemd/user/wall.* $XDG_CONFIG_HOME/systemd/user
systemctl --user enable wall.timer

# fetch cache refresh

cp `dirname $0`/home/$USER/.config/systemd/user/fetch.service $XDG_CONFIG_HOME/systemd/user
systemctl --user enable fetch.service

# aws iam access key refresh

if [[ $HOST = 'worker' ]]; then

  cp `dirname $0`/home/$USER/.config/systemd/user/iam.service $XDG_CONFIG_HOME/systemd/user
  systemctl --user enable iam.service

fi

# group check

sudo grpck

