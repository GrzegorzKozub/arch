#!/usr/bin/env zsh

set -e

# find data partition by uuid (nvme devices are numbered as they init)

[[ $HOST = 'player' ]] &&
  DISK="$(
    lsblk -lno PATH,UUID |
    grep -i '1fbc6b00-f28c-476a-9319-6640fb52d976' |
    cut -d' ' -f1
  )" \
|| DISK=/dev/sda1

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

