#!/usr/bin/env zsh

set -e

# backup

() {

. `dirname $0`/unlock.zsh
. `dirname $0`/mount.zsh

[[ $(df /dev/mapper/vg1-backup --output=avail | grep -v Avail) -lt 10000000 ]] && {
  local oldest="/mnt/$(ls -t /mnt | grep '^[0-9]*$' | tail -n1)"
  echo "removing $oldest"
  rm -rf $oldest
}

local dir=/mnt/$(date +%Y%m%d%H%M)
echo "backing up to $dir"
mkdir $dir

fsarchiver savefs $dir/root.fsa /dev/mapper/vg1-root
cp /mnt/boot/*.img /mnt/boot/vmlinuz-linux $dir/

}
