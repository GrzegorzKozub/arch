#!/usr/bin/env zsh

set -o verbose

# paru

sudo sed -ie 's/IgnorePkg   = pacman/#IgnorePkg   =/' /etc/pacman.conf
sudo pacman -Syu --noconfirm
sudo pacman -Rs --noconfirm paru-git
. `dirname $0`/paru.zsh
reset.zsh rust

# coredump

sudo rm -rf /var/lib/systemd/coredump/*

# ^ done on drifter & player

# auditd

sudo sed -i -e 's/num_logs.*/num_logs = 8/' /etc/audit/auditd.conf

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

