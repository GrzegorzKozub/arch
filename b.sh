#!/usr/bin/env bash
set -eo pipefail -ux

"${BASH_SOURCE%/*}"/unlock.sh
"${BASH_SOURCE%/*}"/mount.sh

BACKUP=/mnt/backup

[[ -d $BACKUP ]] || mkdir -p $BACKUP

backups() { find "$BACKUP" -maxdepth 1 -name '[0-9]*' -type d; }

while [[
  $(df -h /dev/mapper/vg1-data --output=avail | grep -v Avail | sed -E 's/ |G//g') -lt 32 &&
  $(backups | wc -l) -gt 3 ]]; do
  OLDEST=$(backups | sort | head -n1)
  echo "removing $OLDEST"
  rm -rf "$OLDEST"
done

DIR=$BACKUP/$(date +%Y%m%d%H%M)
echo "backing up to $DIR"
mkdir "$DIR"

fsarchiver savefs -j4 -c - "$DIR"/root.fsa /dev/mapper/vg1-root
cp /mnt/boot/*.img /mnt/boot/vmlinuz-linux* "$DIR"/

umount -R /mnt
