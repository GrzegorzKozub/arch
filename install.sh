if [[ "$1" != "root" && "$1" != "backup" ]]; then
  exit 1
fi

set -o verbose

mkfs.ext4 /dev/mapper/vg1-$1

swapon /dev/mapper/vg1-swap
mount /dev/mapper/vg1-$1 /mnt
mkdir /mnt/boot
mount /dev/nvme0n1p2 /mnt/boot

rm /mnt/boot/*.img
rm /mnt/boot/vmlinuz-linux

if [[ "$1" = "root" ]]; then
  pacstrap /mnt \
    base base-devel \
    sudo reflector dialog wpa_supplicant zsh \
    intel-ucode \
    xf86-video-intel xorg-server gnome networkmanager \
    git
else
  pacstrap /mnt \
    base \
    reflector \
    intel-ucode \
    fsarchiver
fi

genfstab -U /mnt > /mnt/etc/fstab

cp -r `dirname $0`/../Arch /mnt/root
arch-chroot /mnt ~/Arch/config.sh
rm -rf /mnt/root/Arch

swapoff /dev/mapper/vg1-swap
umount -R /mnt

