#!/usr/bin/env zsh

set -o verbose

# switch initial ramdisk to systemd based

sudo sed -Ei \
  's/^HOOKS=.+$/HOOKS=(base systemd autodetect microcode modconf kms keyboard sd-vconsole block sd-encrypt lvm2 filesystems fsck)/' \
  /etc/mkinitcpio.conf

source `dirname $0`/$HOST.zsh
sudo cp `dirname $0`/etc/crypttab.initramfs /etc/crypttab.initramfs
sudo sed -i \
  "s/<uuid>/$(sudo blkid -s UUID -o value $MY_ARCH_PART)/g" \
  /etc/crypttab.initramfs

sudo mkinitcpio -p linux
sudo mkinitcpio -p linux-lts

[[ $HOST = 'worker' ]] &&
  sudo sed -i \
    "s/^FONT=.*/FONT=ter-232b/" \
    /etc/vconsole.conf

# delete docker-machine

[[ $(pacman -Qs docker-machine) ]] &&
  sudo pacman -Rs --noconfirm docker-machine

set +o verbose
declare -A ZINIT
export ZINIT[HOME_DIR]=$XDG_DATA_HOME/zinit
export ZINIT[ZCOMPDUMP_PATH]=$XDG_CACHE_HOME/zsh/zcompdump
source $ZINIT[HOME_DIR]/bin/zinit.zsh
zinit delete --yes OMZ::plugins/docker-machine/_docker-machine
set -o verbose

DIR=$XDG_DATA_HOME/zinit/snippets/OMZ::plugins--docker-machine
[[ -d $DIR ]] && rm -rf $DIR

# add tsx

npm install --global tsx

# no need to restrict access to openvpn config

chmod a+r ~/code/keys/openvpn/*

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

