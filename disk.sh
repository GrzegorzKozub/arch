#!/usr/bin/env bash

set -e -o verbose

# validation

[[ ! $MY_DISK || ! $MY_ARCH_PART || ! $MY_HOSTNAME ]] && exit 1

# linux partition

read -p "Ensure a partition of type Linux filesystem is created as $MY_ARCH_PART"
cfdisk $MY_DISK

[[ $(lsblk -lno PATH,PARTTYPE | grep -i '0FC63DAF-8483-4772-8E79-3D69D8477DE4' | cut -d' ' -f1) = $MY_ARCH_PART ]] || exit 1

# encryption

cryptsetup luksFormat --type luks2 $MY_ARCH_PART
cryptsetup luksOpen $MY_ARCH_PART lvm

# logical volumes

pvcreate /dev/mapper/lvm
vgcreate vg1 /dev/mapper/lvm

if [[ $MY_HOSTNAME = 'drifter' ]]; then
  # hibernation
  lvcreate --size 32G vg1 --name swap
else
  lvcreate --size 8G vg1 --name swap
fi

lvcreate -l 67%FREE vg1 -n root
lvcreate -l 100%FREE vg1 -n backup

# format

mkswap /dev/mapper/vg1-swap
mkfs.ext4 /dev/mapper/vg1-root
mkfs.ext4 /dev/mapper/vg1-backup

