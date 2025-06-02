#!/usr/bin/env zsh

set -e

EFI_PART="$(
  lsblk -lno PATH,PARTTYPE,FSTYPE |
  grep -i 'C12A7328-F81F-11D2-BA4B-00A0C93EC93B' |
  grep 'vfat' |
  cut -d' ' -f1
)"

[[ $(mount | grep 'vg1-data on /mnt') ]] || mount /dev/mapper/vg1-data /mnt
[[ -d /mnt/boot ]] || mkdir /mnt/boot
[[ $(mount | grep "$EFI_PART on /mnt/boot") ]] || mount $EFI_PART /mnt/boot

