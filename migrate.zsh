#!/usr/bin/env zsh

set -o verbose

# java

sudo pacman -S --noconfirm jdk21-openjdk
sudo archlinux-java set java-21-openjdk

# only keep coredumps from last 3 days

sudo cp `dirname $0`/etc/tmpfiles.d/coredump.conf /etc/tmpfiles.d

# nvidia undervolt

if [[ $HOST =~ ^(player|worker)$ ]]; then

  cp `dirname $0`/home/$USER/.config/systemd/user/nvidia.{service,timer} $XDG_CONFIG_HOME/systemd/user
  systemctl --user enable nvidia.timer

  sudo systemctl enable nvidia-persistenced.service

fi

# performance optimization

sudo cp `dirname $0`/etc/sysctl.d/70-perf.conf /etc/sysctl.d

cp `dirname $0`/home/$USER/.config/systemd/user/perf.service $XDG_CONFIG_HOME/systemd/user
systemctl --user enable perf.service

# reset

# . `dirname $0`/reset.zsh

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

