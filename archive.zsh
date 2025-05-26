#!/usr/bin/env zsh

set -e

# archive

[[ $HOST = 'player' ]] && DISK=/dev/nvme1n1p1 || DISK=/dev/sda1

MOUNT=/mnt
SOURCE=/run/media/$USER/data/
TARGET=$MOUNT/arch

[[ $(mount | grep "$DISK on $MOUNT") ]] || sudo mount $DISK $MOUNT
[[ -d $TARGET ]] || mkdir $TARGET

FREE=$(df -h $DISK --output=avail | grep -v Avail | sed -E 's/ |G//g' )
[[ $FREE -lt 64 ]] && echo "only ${FREE}G free on $DISK"

rsync \
  --archive \
  --delete \
  --exclude 'boot' \
  --exclude 'lost+found' \
  --human-readable --progress \
  $SOURCE $TARGET

sudo umount -R $MOUNT

