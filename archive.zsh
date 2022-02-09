#!/usr/bin/env zsh

set -e

# archive

() {

local disk=/dev/sda1
local mount=/mnt

[[ $(mount | grep "$disk on $mount") ]] || sudo mount $disk $mount

sudo umount -R $mount

}

