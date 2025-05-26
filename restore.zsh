#!/usr/bin/env zsh

set -e

# restore

. `dirname $0`/unlock.zsh
. `dirname $0`/mount.zsh

BACKUP=/mnt/backup

[[ $1 && -d $1 ]] &&
  DIR=$1 ||
  DIR="$BACKUP/$(ls -t $BACKUP | grep '^[0-9]*$' | head -n1)"

echo "restoring from $DIR"

fsarchiver restfs -c - $DIR/root.fsa id=0,dest=/dev/mapper/vg1-root
cp $DIR/*.img $DIR/vmlinuz-linux* /mnt/boot/

umount -R /mnt

