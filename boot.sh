set -e -o verbose

# mount

if [[ ! $(swapon) ]]; then swapon /dev/mapper/vg1-swap; fi
if [[ ! $(mount | grep "vg1-root on /mnt") ]]; then mount /dev/mapper/vg1-root /mnt; fi
if [[ ! -d /mnt/boot ]]; then mkdir /mnt/boot; fi
if [[ ! $(mount | grep "nvme0n1p2 on /mnt/boot") ]]; then mount /dev/nvme0n1p2 /mnt/boot; fi

# boot manager with secure boot support

cp -r `dirname $0`/../Arch /mnt/root
arch-chroot /mnt ~/Arch/boot2.sh
rm -rf /mnt/root/Arch

# unmount

swapoff /dev/mapper/vg1-swap
umount -R /mnt

