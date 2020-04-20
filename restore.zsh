#!/usr/bin/env zsh

set -e -o verbose

[[ -d $1 ]] || exit 1

fsarchiver restfs $1/root.fsa id=0,dest=/dev/mapper/vg1-root
cp $1/*.img $1/vmlinuz-linux /mnt/boot/

