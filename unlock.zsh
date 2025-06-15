#!/usr/bin/env zsh

set -e

[[ $(lsblk -lno NAME | grep 'vg1') ]] && exit 0

ARCH_PART="$(
  lsblk -lno PATH,PARTTYPE,FSTYPE |
  grep -i '0fc63daf-8483-4772-8e79-3d69d8477de4' |
  grep 'crypto_LUKS' |
  cut -d' ' -f1
)"

cryptsetup luksOpen $ARCH_PART lvm
sleep 1

