set -e -o verbose

# format

mkfs.ext4 /dev/mapper/vg1-root

# mount

swapon /dev/mapper/vg1-swap
mount /dev/mapper/vg1-root /mnt
if [ ! -d /mnt/boot ]; then mkdir /mnt/boot; fi
mount /dev/nvme0n1p2 /mnt/boot

# previous linux kernels

if [ -f /mnt/boot/*.img ]; then rm /mnt/boot/*.img; fi
if [ -f /mnt/boot/vmlinuz-linux ]; then rm /mnt/boot/vmlinuz-linux; fi

# operating system

pacstrap /mnt \
  base base-devel \
  sudo reflector dialog wpa_supplicant zsh \
  intel-ucode \
  xf86-video-intel xorg-server gnome gnome-tweak-tool networkmanager \
  git \
  efibootmgr

# fstab file

genfstab -U /mnt > /mnt/etc/fstab

# config

cp -r `dirname $0`/../Arch /mnt/root
arch-chroot /mnt ~/Arch/system2.sh
rm -rf /mnt/root/Arch

# unmount

swapoff /dev/mapper/vg1-swap
umount -R /mnt

