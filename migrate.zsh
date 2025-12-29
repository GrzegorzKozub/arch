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

# links

rm -rf $XDG_DATA_HOME/applications/org.gnome.ColorProfileViewer.desktop

# firewall

[[ -f /etc/iptables/iptables.rules.backup ]] &&
  sudo mv /etc/iptables/iptables.rules.backup /etc/iptables/iptables.rules
[[ -f /etc/iptables/ip6tables.rules.backup ]] &&
  sudo mv /etc/iptables/ip6tables.rules.backup /etc/iptables/ip6tables.rules
sudo systemctl disable --now iptables.service ip6tables.service

# ...

# vscode

set +e

for EXTENSION in \
  docker.docker \
  github.copilot-chat
do
  code --install-extension $EXTENSION --force
done

set -e

# docker

paru -S --aur --noconfirm docker-scout

PAT=/run/media/$USER/data/.secrets/docker.secret
[[ -f $PAT ]] && cat $PAT | docker login --username grzegorzkozub --password-stdin

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

