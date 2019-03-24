set -o verbose

swapon /dev/mapper/vg1-swap
mount /dev/mapper/vg1-root /mnt
mount /dev/nvme0n1p2 /mnt/boot

cp -r `dirname $0`/../Arch /mnt/root
arch-chroot /mnt ~/Arch/boot2.sh
rm -rf /mnt/root/Arch

swapoff /dev/mapper/vg1-swap
umount -R /mnt

