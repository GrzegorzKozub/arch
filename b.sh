#!/usr/bin/env bash
set -eo pipefail -ux

"${BASH_SOURCE%/*}"/unlock.sh
"${BASH_SOURCE%/*}"/mount.sh

BACKUP=/mnt/backup

[[ -d $BACKUP ]] || mkdir -p $BACKUP

while [[ 
  $(df -h /dev/mapper/vg1-data --output=avail | grep -v Avail | sed -E 's/ |G//g') -lt 32 &&
  $(ls -d $BACKUP/[0-9]* | wc -l) -gt 3 ]] \
  ; do
  OLDEST="$BACKUP/$(ls -t $BACKUP | grep '^[0-9]*$' | tail -n1)"
  echo "removing $OLDEST"
  rm -rf "$OLDEST"
done

DIR=$BACKUP/$(date +%Y%m%d%H%M)
echo "backing up to $DIR"
mkdir "$DIR"

fsarchiver savefs -j4 -c - "$DIR"/root.fsa /dev/mapper/vg1-root
cp /mnt/boot/*.img /mnt/boot/vmlinuz-linux* "$DIR"/

umount -R /mnt
