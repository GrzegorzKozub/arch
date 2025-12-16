#!/usr/bin/env zsh

set -o verbose

# pacman (paru)

# sudo sed -ie 's/IgnorePkg   = pacman/#IgnorePkg   =/' /etc/pacman.conf

# coredump

sudo rm -rf /var/lib/systemd/coredump/*

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

