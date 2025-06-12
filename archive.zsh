#!/usr/bin/env zsh

set -e

# find backup partition by uuid (nvme devices are numbered as they init)

[[ $HOST = 'player' ]] &&
  DISK="$(
    lsblk -lno PATH,UUID |
    grep -i '5587CEC71012FFFA' |
    cut -d' ' -f1
  )" \
|| DISK=/dev/sda1

MOUNT=/mnt
SOURCE=/run/media/$USER/data/
TARGET=$MOUNT/arch

[[ $(mount | grep "$DISK on $MOUNT") ]] || sudo mount $DISK $MOUNT
[[ -d $TARGET ]] || mkdir $TARGET

FREE=$(df --human-readable $DISK --output=avail | grep -v Avail | sed -E 's/ |G//g' )
[[ $FREE -lt 64 ]] && echo "only ${FREE}G free on $DISK"

# rsync \
#   --archive \
#   --delete \
#   --exclude 'lost+found' \
#   --human-readable --progress \
#   $SOURCE $TARGET

rclone sync \
  --exclude 'lost+found/**' \
  --modify-window 100ns \
  --progress \
  $SOURCE $TARGET

sudo umount -R $MOUNT

