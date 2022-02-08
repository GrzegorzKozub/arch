#!/usr/bin/env zsh

set -e

# config

# mount

[[ $(mount | grep '/dev/sda1 on /mnt') ]] || sudo mount /dev/sda1 /mnt

# unmount

sudo umount -R /mnt

