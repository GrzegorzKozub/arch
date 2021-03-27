#!/usr/bin/env zsh

set -e -o verbose

() {

[[ $(df /dev/mapper/vg1-backup --output=avail | grep -v Avail) -lt 10000000 ]] && {
  rm -rf "/mnt/$(ls -t /mnt | grep '^[0-9]*$' | tail -n1)"
}

local dir=/mnt/$(date +%Y%m%d%H%M)
sudo mkdir $dir

fsarchiver savefs $dir/root.fsa /dev/mapper/vg1-root
cp /mnt/boot/*.img /mnt/boot/vmlinuz-linux $dir/

}
