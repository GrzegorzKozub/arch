#!/usr/bin/env zsh

set -e

# restore

() {

. $1/unlock.zsh
. $1/mount.zsh

local backup=/mnt/backup

[[ $2 && -d $2 ]] &&
  local dir=$2 ||
  local dir="$backup/$(ls -t $backup | grep '^[0-9]*$' | head -n1)"

echo "restoring from $dir"

fsarchiver restfs -c - $dir/root.fsa id=0,dest=/dev/mapper/vg1-root
cp $dir/*.img $dir/vmlinuz-linux* /mnt/boot/

umount -R /mnt

} `dirname $0` $1
