#!/usr/bin/env bash
set -eo pipefail -ux

"${BASH_SOURCE%/*}"/unlock.sh
"${BASH_SOURCE%/*}"/mount.sh

BACKUP=/mnt/backup

backups() { find "$BACKUP" -maxdepth 1 -name '[0-9]*' -type d; }

[[ $1 && -d $1 ]] &&
  DIR=$1 ||
  DIR=$(backups | sort | tail -n1)

echo "restoring from $DIR"

fsarchiver restfs -c - "$DIR"/root.fsa id=0,dest=/dev/mapper/vg1-root
cp "$DIR"/*.img "$DIR"/vmlinuz-linux* /mnt/boot/

umount -R /mnt
