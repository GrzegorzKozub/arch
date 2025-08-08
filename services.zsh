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

# if [[ $HOST =~ ^(player|worker)$ ]]; then
#
#   cp `dirname $0`/home/$USER/.config/systemd/user/imwheel.service $XDG_CONFIG_HOME/systemd/user
#   systemctl --user enable imwheel.service
#
# fi

# sync

cp `dirname $0`/home/$USER/.config/systemd/user/sync-* $XDG_CONFIG_HOME/systemd/user
systemctl --user enable sync-periodic.timer
systemctl --user enable sync-session.service

# lact

if [[ $HOST =~ ^(player|sacrifice|worker)$ ]]; then

  sudo systemctl enable lactd.service

fi

# amd gpu fan speed

if [[ $HOST = 'sacrifice' ]]; then

  [[ -d /etc/amdfand ]] || sudo mkdir /etc/amdfand
  sudo cp `dirname $0`/etc/amdfand/config.toml /etc/amdfand/config.toml
  sudo systemctl enable amdfand.service

fi

# preserve nvidia video during suspend

if [[ $HOST =~ ^(player|worker)$ ]]; then

  sudo systemctl enable nvidia-hibernate.service
  sudo systemctl enable nvidia-resume.service
  sudo systemctl enable nvidia-suspend.service

fi

# colors & night light

# if [[ $HOST =~ ^(player|worker)$ ]]; then
#
#   # conflicts with dispwin
#   sudo systemctl mask colord.service
#
#   cp `dirname $0`/home/$USER/.config/systemd/user/colors.service $XDG_CONFIG_HOME/systemd/user
#   systemctl --user enable colors.service
#
#   cp `dirname $0`/home/$USER/.config/systemd/user/redshift.service $XDG_CONFIG_HOME/systemd/user
#   systemctl --user enable redshift.service
#
# fi
#
# if [[ $HOST = 'player' ]]; then
#
#   dispwin -d1 -I `dirname $0`/home/$USER/.config/color/icc/devices/display/27gp950-b.icm
#
# fi
#
# if [[ $HOST = 'worker' ]]; then
#
#   dispwin -d1 -I `dirname $0`/home/$USER/.config/color/icc/devices/display/27ul850-w.icm
#   dispwin -d2 -I `dirname $0`/home/$USER/.config/color/icc/devices/display/27ud88-w.icm
#
# fi

# audio

[[ -d $XDG_CONFIG_HOME/pipewire/pipewire.conf.d ]] || mkdir -p $XDG_CONFIG_HOME/pipewire/pipewire.conf.d
cp `dirname $0`/home/$USER/.config/pipewire/pipewire.conf.d/10-clock-rate.conf $XDG_CONFIG_HOME/pipewire/pipewire.conf.d

if [[ -f `dirname $0`/home/$USER/.config/wireplumber/wireplumber.conf.d/$HOST.conf ]]; then

  [[ -d $XDG_CONFIG_HOME/wireplumber/wireplumber.conf.d ]] || mkdir -p $XDG_CONFIG_HOME/wireplumber/wireplumber.conf.d
  cp `dirname $0`/home/$USER/.config/wireplumber/wireplumber.conf.d/$HOST.conf $XDG_CONFIG_HOME/wireplumber/wireplumber.conf.d/audio.conf

fi

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

# fetch cache refresh

cp `dirname $0`/home/$USER/.config/systemd/user/fetch.service $XDG_CONFIG_HOME/systemd/user
systemctl --user enable fetch.service

# aws iam access key refresh

if [[ $HOST = 'worker' ]]; then

  cp `dirname $0`/home/$USER/.config/systemd/user/iam.service $XDG_CONFIG_HOME/systemd/user
  systemctl --user enable iam.service

  . `dirname $0`/work.zsh

fi

# group check

sudo grpck

