#!/usr/bin/env zsh

set -e

# unlock

() {

[[ $(lsblk -lno PATH | grep 'vg1') ]] && exit 1

local arch_part="$(lsblk -lno PATH,PARTTYPE | grep -i '0FC63DAF-8483-4772-8E79-3D69D8477DE4' | cut -d' ' -f1)"

cryptsetup luksOpen $arch_part lvm
sleep 1

}

