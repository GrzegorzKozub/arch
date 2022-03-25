#!/usr/bin/env zsh

set -e

# archive

() {

local disk=/dev/sda1
local mount=/mnt
local source=/run/media/$USER/data/backup
local target=$mount/arch

[[ $(mount | grep "$disk on $mount") ]] || sudo mount $disk $mount
[[ -d $target ]] || mkdir $target

local free=$(df -h $disk --output=avail | grep -v Avail | sed -E 's/ |G//g' )
[[ $free -lt 50 ]] && echo "only ${free}G free on $disk"

rsync \
  --archive \
  --exclude 'boot' \
  --exclude 'lost+found' \
  --human-readable --progress \
  $source $target

sudo umount -R $mount

}

