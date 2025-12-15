#!/usr/bin/env zsh

set -o verbose

# hosts

if [[ $HOST = 'player' ]]; then

  sudo sed -i -e "/.*localhost.*/d" /etc/hosts
  sudo sed -i -e "/.*$HOST.*/d" /etc/hosts

  echo '127.0.0.1 localhost' | sudo tee --append /etc/hosts
  echo '::1       localhost' | sudo tee --append /etc/hosts
  echo "127.0.0.1 $HOST.localdomain $HOST" | sudo tee --append /etc/hosts
  echo "::1       $HOST.localdomain $HOST" | sudo tee --append /etc/hosts

fi

# cleanup & tweaks

sudo cp `dirname $0`/etc/tmpfiles.d/coredump.conf /etc/tmpfiles.d

[[ -d /etc/systemd/system.conf.d ]] || sudo mkdir /etc/systemd/system.conf.d
sudo cp `dirname $0`/etc/systemd/system.conf.d/00-timeout.conf /etc/systemd/system.conf.d

[[ -d /etc/systemd/timesyncd.conf.d ]] || sudo mkdir /etc/systemd/timesyncd.conf.d
sudo cp $(dirname $0)/etc/systemd/timesyncd.conf.d/ntp.conf /etc/systemd/timesyncd.conf.d

[[ -d /etc/systemd/journald.conf.d ]] || sudo mkdir /etc/systemd/journald.conf.d
sudo cp `dirname $0`/etc/systemd/journald.conf.d/00-size.conf /etc/systemd/journald.conf.d

[[ -d /etc/systemd/system/rtkit-daemon.service.d ]] || sudo mkdir /etc/systemd/system/rtkit-daemon.service.d
sudo cp `dirname $0`/etc/systemd/system/rtkit-daemon.service.d/log.conf /etc/systemd/system/rtkit-daemon.service.d

sudo cp `dirname $0`/etc/sysctl.d/70-perf.conf /etc/sysctl.d
sudo cp `dirname $0`/etc/udev/rules.d/60-ioschedulers.rules /etc/udev/rules.d


if [[ $HOST =~ ^(player|worker)$ ]]; then

  cp `dirname $0`/home/$USER/.config/systemd/user/nvidia.{service,timer} $XDG_CONFIG_HOME/systemd/user
  systemctl --user enable nvidia.timer

  sudo systemctl enable nvidia-persistenced.service

fi

[[ $HOST = 'worker' ]] &&
  sudo mv /etc/udev/rules.d/10-c922.rules /etc/udev/rules.d/90-c922.rules

if [[ $HOST =~ ^(player|worker)$ ]]; then

  sudo rm -f /usr/lib/tmpfiles.d/wakeup.conf
  sudo cp $(dirname $0)/etc/tmpfiles.d/wakeup.conf /etc/tmpfiles.d

fi

cp `dirname $0`/home/$USER/.config/systemd/user/perf.service $XDG_CONFIG_HOME/systemd/user
systemctl --user enable perf.service

# java

if [[ $HOST =~ ^(drifter|worker)$ ]]; then # work

  sudo pacman -S --noconfirm jdk21-openjdk
  sudo archlinux-java set java-21-openjdk

fi

# wifi regulatory domain

sudo pacman -S --noconfirm wireless-regdb
sudo sed -i 's/#WIRELESS_REGDOM="PL"/WIRELESS_REGDOM="PL"/' /etc/conf.d/wireless-regdom

# apparmor

# sudo pacman -S --noconfirm apparmor
# paru -S --aur --noconfirm apparmor.d-git
#
# sudo sed -i \
#   -e 's/log_level=3.*/log_level=3 lsm=landlock,lockdown,yama,integrity,apparmor,bpf/' \
#   /boot/loader/entries/{arch,arch-lts}.conf
#
# sudo sed -i \
#   -e 's/#write-cache/write-cache/' \
#   -e 's/#Optimize=compress-fast/Optimize=compress-fast/' \
#   /etc/apparmor/parser.conf
#
# sudo systemctl enable apparmor.service

# reset

# . `dirname $0`/reset.zsh

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

