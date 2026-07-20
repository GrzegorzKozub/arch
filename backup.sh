#!/usr/bin/env bash
set -eo pipefail -u

# find backup partition by uuid (nvme devices are numbered as they init)
[[ $HOST == 'drifter' ]] && UUID='0450688250687bf4'
[[ $HOST == 'player' ]] && UUID='a41afb701afb3dbc'
[[ $HOST == 'worker' ]] && UUID='5587cec71012fffa'
DISK="$(lsblk -lno PATH,UUID | grep -i "$UUID" | cut -d' ' -f1)"

MOUNT=/mnt
SOURCE=/run/media/$USER/data/
TARGET=$MOUNT/Backup/arch

mount | grep -q "$DISK on $MOUNT" ||
  sudo mount -o uid="$(id -u)",gid="$(id -g)" "$DISK" $MOUNT

[[ -d $TARGET ]] || mkdir -p $TARGET

FREE=$(df --block-size=1G "$DISK" --output=avail | grep -v Avail | tr -dc '0-9')
[[ $FREE -lt 64 ]] && echo "only ${FREE}G free on $DISK"

rclone sync \
  --exclude '.cache/**' \
  --exclude '.config/**' \
  --exclude '.data/**' \
  --exclude '.secrets/**' \
  --exclude ".Trash-$(id -u)/**" \
  --exclude 'boot/**' \
  --exclude 'katie/**' \
  --exclude 'lost+found/**' \
  --modify-window 100ns \
  --progress \
  "$SOURCE" $TARGET

sudo umount -R $MOUNT
