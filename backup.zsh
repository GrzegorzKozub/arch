#!/usr/bin/env zsh

set -e

# backup

() {

. $1/unlock.zsh
. $1/mount.zsh

local backup=/mnt/backup

[[ -d $backup ]] || mkdir -p $backup

while [[ \
  $(df -h /dev/mapper/vg1-data --output=avail | grep -v Avail | sed -E 's/ |G//g') -lt 10 && \
  $(ls -d $backup/[0-9]* | wc -l) -gt 3 \
]]; do
  local oldest="$backup/$(ls -t /mnt | grep '^[0-9]*$' | tail -n1)"
  echo "removing $oldest"
  rm -rf $oldest
done

local dir=$backup/$(date +%Y%m%d%H%M)
echo "backing up to $dir"
mkdir $dir

fsarchiver savefs -j $(nproc) -c - $dir/root.fsa /dev/mapper/vg1-root
cp /mnt/boot/*.img /mnt/boot/vmlinuz-linux* $dir/

umount -R /mnt

} `dirname $0`



