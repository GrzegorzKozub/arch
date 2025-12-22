#!/usr/bin/env zsh

set -o verbose

# shutdown bug: https://bbs.archlinux.org/viewtopic.php?pid=2278862

if [[ $HOST = 'worker' ]]; then

  # paru

  sudo sed -ie 's/IgnorePkg   = pacman/#IgnorePkg   =/' /etc/pacman.conf
  sudo pacman -Syu --noconfirm
  sudo pacman -Rs --noconfirm paru-git
  . `dirname $0`/paru.zsh
  reset.zsh rust

  # coredump

  sudo rm -rf /var/lib/systemd/coredump/*

fi

# amd chipset

[[ $HOST =~ ^(player|worker)$ ]] &&
  sudo cp `dirname $0`/etc/modprobe.d/amd.conf /etc/modprobe.d

# auditd

sudo sed -i 's/num_logs.*/num_logs = 8/' /etc/audit/auditd.conf

# hl

sudo pacman -S --noconfirm hl

# claude

for FILE in \
  ~/code/dot/zsh/zsh/.zshenv \
  /run/media/greg/data/.secrets/.zshenv
do
  sed -i 's/export ANTHROPIC_API_KEY.*/export ANTHROPIC_API_KEY=/' $FILE
done

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

