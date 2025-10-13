#!/usr/bin/env zsh

set -e

if [[ $HOST == 'drifter' ]]; then
  DISK=/dev/sda1
else
  # find backup partition by uuid (nvme devices are numbered as they init)
  [[ $HOST == 'player' ]] && UUID='a41afb701afb3dbc'
  [[ $HOST == 'worker' ]] && UUID='5587cec71012fffa'
  DISK="$(lsblk -lno PATH,UUID | grep -i $UUID | cut -d' ' -f1)"
fi

MOUNT=/mnt
SOURCE=/run/media/$USER/data/
TARGET=$MOUNT/arch

[[ $(mount | grep "$DISK on $MOUNT") ]] || sudo mount $DISK $MOUNT
[[ -d $TARGET ]] || mkdir $TARGET

FREE=$(df --human-readable $DISK --output=avail | grep -v Avail | sed -E 's/ |G//g' )
[[ $FREE -lt 64 ]] && echo "only ${FREE}G free on $DISK"

rclone sync \
  --exclude 'boot/**' \
  --exclude 'lost+found/**' \
  --modify-window 100ns \
  --progress \
  $SOURCE $TARGET

sudo umount -R $MOUNT

