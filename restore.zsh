#!/usr/bin/env zsh

set -e -o verbose

() {

[[ $1 && -d $1 ]] &&
  local dir=$1 ||
  local dir="/mnt/$(ls -t /mnt | grep '^[0-9]*$' | head -n1)"

fsarchiver restfs $dir/root.fsa id=0,dest=/dev/mapper/vg1-root
cp $dir/*.img $dir/vmlinuz-linux /mnt/boot/

} $1
