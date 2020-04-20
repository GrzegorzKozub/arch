#!/usr/bin/env zsh

set -e -o verbose

# unlock

ARCH_PART="$(lsblk -lno PATH,PARTTYPE | grep -i '0FC63DAF-8483-4772-8E79-3D69D8477DE4' | cut -d' ' -f1)"

cryptsetup luksOpen $ARCH_PART lvm
sleep 1

unset ARCH_PART

