#!/usr/bin/env zsh

set -o verbose

# limit journal size to 64 MB

[[ -d /etc/systemd/journald.conf.d ]] || sudo mkdir /etc/systemd/journald.conf.d
sudo cp `dirname $0`/etc/systemd/journald.conf.d/00-journal-size.conf /etc/systemd/journald.conf.d

# limit journal entries

[[ -d /etc/systemd/system/rtkit-daemon.service.d ]] || sudo mkdir /etc/systemd/system/rtkit-daemon.service.d
sudo cp $(dirname $0)/etc/systemd/system/rtkit-daemon.service.d/log.conf /etc/systemd/system/rtkit-daemon.service.d

# only keep coredumps from last 3 days

sudo cp `dirname $0`/etc/tmpfiles.d/coredump.conf /etc/tmpfiles.d

# performance optimization

sudo cp `dirname $0`/etc/sysctl.d/70-perf.conf /etc/sysctl.d

cp `dirname $0`/home/$USER/.config/systemd/user/perf.service $XDG_CONFIG_HOME/systemd/user
systemctl --user enable perf.service

# nvidia undervolt

if [[ $HOST =~ ^(player|worker)$ ]]; then

  cp `dirname $0`/home/$USER/.config/systemd/user/nvidia.{service,timer} $XDG_CONFIG_HOME/systemd/user
  systemctl --user enable nvidia.timer

  sudo systemctl enable nvidia-persistenced.service

fi

# java

if [[ $HOST =~ ^(drifter|worker)$ ]]; then # work

  sudo pacman -S --noconfirm jdk21-openjdk
  sudo archlinux-java set java-21-openjdk

fi

# reset

# . `dirname $0`/reset.zsh

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

