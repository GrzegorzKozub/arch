#!/usr/bin/env zsh

set -e -o verbose

# env

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-~/.config}

# dirs

[[ -d $XDG_CONFIG_HOME/systemd/user ]] || mkdir -p $XDG_CONFIG_HOME/systemd/user

# time sync

sudo timedatectl set-ntp true

# package management

sudo systemctl enable pkgfile-update.timer
sudo systemctl enable reflector.timer

# ssd

sudo systemctl enable fstrim.timer

# mdns with avahi (nss-mdns)

# sudo sed -i \
#   -e 's/mymachines resolve/mymachines mdns_minimal [NOTFOUND=return] resolve/' \
#   /etc/nsswitch.conf
# sudo systemctl enable avahi-daemon.service

# dns with systemd-resolved

[[ -d /etc/systemd/resolved.conf.d ]] || sudo mkdir /etc/systemd/resolved.conf.d
sudo cp `dirname $0`/etc/systemd/resolved.conf.d/dns.conf /etc/systemd/resolved.conf.d

[[ -d /etc/NetworkManager/conf.d ]] || sudo mkdir /etc/NetworkManager/conf.d
sudo cp `dirname $0`/etc/NetworkManager/conf.d/dns.conf /etc/NetworkManager/conf.d

sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

sudo systemctl enable systemd-resolved

# network

sudo systemctl enable NetworkManager.service

# firewall

sudo cp /etc/iptables/iptables.rules /etc/iptables/iptables.rules.backup
sudo cp `dirname $0`/etc/iptables/iptables.rules /etc/iptables
sudo systemctl enable iptables.service

sudo cp /etc/iptables/ip6tables.rules /etc/iptables/ip6tables.rules.backup
sudo cp `dirname $0`/etc/iptables/ip6tables.rules /etc/iptables
sudo systemctl enable ip6tables.service

# sudo cp /etc/nftables.conf /etc/nftables.conf.backup
# sudo cp `dirname $0`/etc/nftables.rules /etc
# sudo systemctl enable nftables.service

# auditd

# sudo systemctl enable auditd.service

# apparmor

# sudo systemctl enable apparmor.service

# bluetooth

sudo systemctl enable bluetooth.service

# gdm

sudo systemctl enable gdm.service

# lact

if [[ $HOST =~ ^(player|worker)$ ]]; then

  sudo systemctl enable lactd.service

fi

# amd gpu fan speed

if [[ $HOST = 'sacrifice' ]]; then

  [[ -d /etc/amdfand ]] || sudo mkdir /etc/amdfand
  sudo cp `dirname $0`/etc/amdfand/config.toml /etc/amdfand
  sudo systemctl enable amdfand.service

fi

# nvidia gpu

if [[ $HOST =~ ^(player|worker)$ ]]; then

  # preserve nvidia video memory during suspend

  sudo systemctl enable nvidia-hibernate.service
  sudo systemctl enable nvidia-resume.service
  sudo systemctl enable nvidia-suspend.service

  # nvidia overclocking

  cp `dirname $0`/home/$USER/.config/systemd/user/nvidia.{service,timer} $XDG_CONFIG_HOME/systemd/user
  systemctl --user enable nvidia.timer

  sudo systemctl enable nvidia-persistenced.service

fi

# audio

[[ -d $XDG_CONFIG_HOME/pipewire/pipewire.conf.d ]] || mkdir -p $XDG_CONFIG_HOME/pipewire/pipewire.conf.d
cp `dirname $0`/home/$USER/.config/pipewire/pipewire.conf.d/10-clock-rate.conf $XDG_CONFIG_HOME/pipewire/pipewire.conf.d

# if [[ -f `dirname $0`/home/$USER/.config/wireplumber/wireplumber.conf.d/$HOST.conf ]]; then
#
#   [[ -d $XDG_CONFIG_HOME/wireplumber/wireplumber.conf.d ]] || mkdir -p $XDG_CONFIG_HOME/wireplumber/wireplumber.conf.d
#   cp `dirname $0`/home/$USER/.config/wireplumber/wireplumber.conf.d/$HOST.conf $XDG_CONFIG_HOME/wireplumber/wireplumber.conf.d/audio.conf
#
# fi

systemctl --user enable pipewire-pulse.service

# performance optimization

cp `dirname $0`/home/$USER/.config/systemd/user/perf.service $XDG_CONFIG_HOME/systemd/user
systemctl --user enable perf.service

# sync

cp `dirname $0`/home/$USER/.config/systemd/user/sync-* $XDG_CONFIG_HOME/systemd/user
systemctl --user enable sync-periodic.timer
systemctl --user enable sync-session.service

# fetch cache refresh

cp `dirname $0`/home/$USER/.config/systemd/user/fetch.service $XDG_CONFIG_HOME/systemd/user
systemctl --user enable fetch.service

# random wallpaper every hour

cp `dirname $0`/home/$USER/.config/systemd/user/wall.* $XDG_CONFIG_HOME/systemd/user
systemctl --user enable wall.timer

# do not disturb

if [[ $XDG_CURRENT_DESKTOP = 'GNOME' ]]; then

  cp `dirname $0`/home/$USER/.config/systemd/user/dnd.service $XDG_CONFIG_HOME/systemd/user
  systemctl --user enable dnd.service

fi

# fonts

[[ -d $XDG_CONFIG_HOME/fontconfig ]] || mkdir -p $XDG_CONFIG_HOME/fontconfig
cp `dirname $0`/home/$USER/.config/fontconfig/fonts.conf $XDG_CONFIG_HOME/fontconfig
fc-cache -f

if [[ $HOST == 'worker' ]]; then # work

  # aws iam access key refresh

  cp `dirname $0`/home/$USER/.config/systemd/user/iam.service $XDG_CONFIG_HOME/systemd/user
  systemctl --user enable iam.service

fi

# group check

sudo grpck

