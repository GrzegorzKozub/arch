#!/usr/bin/env zsh

set -o verbose

# firmware

sudo pacman -S --noconfirm linux-firmware-qlogic
paru -S --aur --noconfirm ast-firmware

# dm-crypt

sudo sed -i \
  's/discard$/allow-discards,no-read-workqueue,no-write-workqueue,tpm2-device=auto/' \
  /etc/crypttab.initramfs

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

