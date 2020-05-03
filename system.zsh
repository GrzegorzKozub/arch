#!/usr/bin/env zsh

set -e -o verbose

# validation

[[ $MY_HOSTNAME ]] || exit 1
[[ $MY_EFI_PART && $(lsblk -lno PATH,PARTTYPE | grep -i 'C12A7328-F81F-11D2-BA4B-00A0C93EC93B' | cut -d' ' -f1) = $MY_EFI_PART ]] || exit 1

# format

[[ $(mount | grep 'vg1-root on /mnt') ]] && umount -R /mnt
mkfs.ext4 /dev/mapper/vg1-root

# mount

[[ $(swapon) ]] || swapon /dev/mapper/vg1-swap
[[ $(mount | grep 'vg1-root on /mnt') ]] || mount /dev/mapper/vg1-root /mnt
[[ -d /mnt/boot ]] || mkdir /mnt/boot
[[ $(mount | grep "$MY_EFI_PART on /mnt/boot") ]] || mount $MY_EFI_PART /mnt/boot

# previous linux kernels

for FILE in \
  /mnt/boot/initramfs-linux.img \
  /mnt/boot/initramfs-linux-fallback.img \
  /mnt/boot/intel-ucode.img \
  /mnt/boot/vmlinuz-linux
do
  [[ -f $FILE ]] && rm $FILE
done

# operating system

pacstrap /mnt \
  base base-devel \
  linux linux-firmware \
  intel-ucode alsa-utils \
  efibootmgr \
  lvm2 \
  nss-mdns \
  v4l-utils \
  git go reflector sudo zsh \
  xorg-server xorg-xrandr \
  gdm gnome-menus gnome-shell gnome-shell-extensions gnome-keyring gvfs gvfs-smb networkmanager xdg-user-dirs-gtk \
  pipewire xdg-desktop-portal \
  eog evince gnome-calculator gnome-control-center gnome-software gnome-system-monitor gnome-terminal gnome-tweak-tool nautilus

# fstab file

genfstab -U /mnt > /mnt/etc/fstab

# config

cp -r `dirname $0`/../arch /mnt/root
arch-chroot /mnt ~/arch/system2.sh
rm -rf /mnt/root/arch

# unmount

swapoff /dev/mapper/vg1-swap
umount -R /mnt

