#!/usr/bin/env zsh

set -o verbose

# shutdown bug: https://bbs.archlinux.org/viewtopic.php?pid=2278862
#
# pacman bug: https://forum.endeavouros.com/t/solved-latest-pacman-update-breaks-aur-and-yay/76959/92
# sudo rm -rf /var/cache/pacman/pkg/download-*

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

# keys

pushd ~/code/keys

for ITEM ('pubring.kbx' 'pubring.kbx~' 'random_seed')
  git update-index --assume-unchanged gnupg/gnupg/$ITEM

popd

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

