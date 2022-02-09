#!/usr/bin/env zsh

set -e

# archive

() {

local source=/run/media/$USER/backup/
local disk=/dev/sda1
local mount=/mnt

[[ $(mount | grep "$disk on $mount") ]] || sudo mount $disk $mount

rsync \
  --archive --delete --delete-excluded \
  --exclude 'boot' \
  --exclude 'lost+found' \
  --exclude 'vm' \
  --human-readable --progress \
  $source $mount

sudo umount -R $mount

}

