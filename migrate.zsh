#!/usr/bin/env zsh

set -o verbose

# firmware

if [[ $HOST =~ ^(drifter|player)$ ]]; then
  sudo pacman -S --noconfirm linux-firmware-qlogic
  paru -S --aur --noconfirm ast-firmware
fi

# dm-crypt

sudo sed -i \
  's/discard$/allow-discards,tpm2-device=auto/' \
  /etc/crypttab.initramfs

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

