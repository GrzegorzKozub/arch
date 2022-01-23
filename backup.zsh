#!/usr/bin/env zsh

set -e

# backup

() {

. $1/unlock.zsh
. $1/mount.zsh

while [[ $(df /dev/mapper/vg1-backup --output=avail | grep -v Avail) -lt 12000000 ]]; do
  local oldest="/mnt/$(ls -t /mnt | grep '^[0-9]*$' | tail -n1)"
  echo "removing $oldest"
  rm -rf $oldest
done

local dir=/mnt/$(date +%Y%m%d%H%M)
echo "backing up to $dir"
mkdir $dir

fsarchiver savefs -c - $dir/root.fsa /dev/mapper/vg1-root
cp /mnt/boot/*.img /mnt/boot/vmlinuz-linux* $dir/

} `dirname $0`
