#!/usr/bin/env zsh

set -e

EFI_PART="$(
  lsblk -lno PATH,PARTTYPE,FSTYPE |
  grep -i 'c12a7328-f81f-11d2-ba4b-00a0c93ec93b' |
  grep 'vfat' |
  cut -d' ' -f1
)"

[[ $(mount | grep 'vg1-data on /mnt') ]] || mount /dev/mapper/vg1-data /mnt
[[ -d /mnt/boot ]] || mkdir /mnt/boot
[[ $(mount | grep "$EFI_PART on /mnt/boot") ]] || mount $EFI_PART /mnt/boot

