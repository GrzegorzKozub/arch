#!/usr/bin/env zsh

set -o verbose

# dns

sudo sed -i 's/hosts.*/hosts: mymachines resolve [!UNAVAIL=return] files myhostname dns/' /etc/nsswitch.conf
sudo systemctl disable avahi-daemon.service
sudo pacman -Rs --noconfirm nss-mdns

# reset

# . `dirname $0`/reset.zsh

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

