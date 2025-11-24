#!/usr/bin/env zsh

set -o verbose

# dns

sudo sed -i 's/hosts.*/hosts: mymachines resolve [!UNAVAIL=return] files myhostname dns/' /etc/nsswitch.conf
sudo systemctl disable avahi-daemon.service
sudo systemctl disable avahi-daemon.socket
sudo pacman -Rs --noconfirm nss-mdns

[[ -d /etc/systemd/resolved.conf.d ]] || sudo mkdir /etc/systemd/resolved.conf.d
sudo cp `dirname $0`/etc/systemd/resolved.conf.d/dns.conf /etc/systemd/resolved.conf.d/dns.conf

[[ -d /etc/NetworkManager/conf.d ]] || sudo mkdir /etc/NetworkManager/conf.d
sudo cp `dirname $0`/etc/NetworkManager/conf.d/dns.conf /etc/NetworkManager/conf.d/dns.conf

sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

sudo systemctl enable --now systemd-resolved
sudo systemctl restart NetworkManager

# reset

# . `dirname $0`/reset.zsh

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

