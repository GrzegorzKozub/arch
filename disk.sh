set -o verbose

cfdisk /dev/nvme0n1

cryptsetup luksFormat --type luks2 /dev/nvme0n1p6
cryptsetup luksOpen /dev/nvme0n1p6 lvm

pvcreate /dev/mapper/lvm
vgcreate vg1 /dev/mapper/lvm

lvcreate --size 8G vg1 --name swap
lvcreate -l 50%FREE vg1 -n root
lvcreate -l 100%FREE vg1 -n backup

mkswap /dev/mapper/vg1-swap
mkfs.ext4 /dev/mapper/vg1-root
mkfs.ext4 /dev/mapper/vg1-backup

