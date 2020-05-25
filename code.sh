#!/bin/sh

sudo mount /dev/mapper/vg1-backup /mnt

sudo rsync \
  --archive \
  --delete \
  --include '.gitkeep' \
  --exclude 'node_modules/*' \
  ~/code /mnt

sudo umount -R /mnt
