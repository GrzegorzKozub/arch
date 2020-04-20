#!/usr/bin/env zsh

set -e -o verbose

# mount

EFI_PART="$(lsblk -lno PATH,PARTTYPE | grep -i 'C12A7328-F81F-11D2-BA4B-00A0C93EC93B' | cut -d' ' -f1)"

[[ $(mount | grep 'vg1-backup on /mnt') ]] || mount /dev/mapper/vg1-backup /mnt
[[ -d /mnt/boot ]] || mkdir /mnt/boot
[[ $(mount | grep "$EFI_PART on /mnt/boot") ]] ||  mount $EFI_PART /mnt/boot

unset EFI_PART

