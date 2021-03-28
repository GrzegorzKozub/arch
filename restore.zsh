#!/usr/bin/env zsh

set -e

# restore

() {

[[ $1 && -d $1 ]] &&
  local dir=$1 ||
  local dir="/mnt/$(ls -t /mnt | grep '^[0-9]*$' | head -n1)"

echo "restoring from $dir"

fsarchiver restfs $dir/root.fsa id=0,dest=/dev/mapper/vg1-root
cp $dir/*.img $dir/vmlinuz-linux /mnt/boot/

} $1
