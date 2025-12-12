#!/usr/bin/env zsh

set -o verbose

# delayed sysfs settings

cp `dirname $0`/home/$USER/.config/systemd/user/sysfs.service $XDG_CONFIG_HOME/systemd/user
systemctl --user enable sysfs.service

# java

sudo pacman -S --noconfirm jdk21-openjdk
sudo archlinux-java set java-21-openjdk

# pci latency

cp `dirname $0`/home/$USER/.config/systemd/user/pci.service $XDG_CONFIG_HOME/systemd/user
systemctl --user enable pci.service

# reset

# . `dirname $0`/reset.zsh

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

