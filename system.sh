set -e -o verbose

# format

if [[ $(mount | grep "vg1-root on /mnt") ]]; then umount -R /mnt; fi
mkfs.ext4 /dev/mapper/vg1-root

# mount

if [[ ! $(swapon) ]]; then swapon /dev/mapper/vg1-swap; fi
if [[ ! $(mount | grep "vg1-root on /mnt") ]]; then mount /dev/mapper/vg1-root /mnt; fi
if [[ ! -d /mnt/boot ]]; then mkdir /mnt/boot; fi
if [[ ! $(mount | grep "nvme0n1p2 on /mnt/boot") ]]; then mount /dev/nvme0n1p2 /mnt/boot; fi

# previous linux kernels

if [ -f /mnt/boot/initramfs-linux.img ]; then rm /mnt/boot/initramfs-linux.img; fi
if [ -f /mnt/boot/initramfs-linux-fallback.img ]; then rm /mnt/boot/initramfs-linux-fallback.img; fi
if [ -f /mnt/boot/intel-ucode.img ]; then rm /mnt/boot/intel-ucode.img; fi
if [ -f /mnt/boot/vmlinuz-linux ]; then rm /mnt/boot/vmlinuz-linux; fi

# operating system

pacstrap /mnt \
  base base-devel \
  linux linux-firmware \
  intel-ucode xf86-video-intel alsa-utils \
  efibootmgr \
  lvm2 \
  dialog dhcpcd netctl wpa_supplicant \
  git go reflector sudo zsh \
  xorg-server xorg-xrandr \
  gdm gnome-menus gnome-shell gnome-shell-extensions gnome-keyring gvfs gvfs-smb networkmanager xdg-user-dirs-gtk \
  eog evince gnome-control-center gnome-software gnome-system-monitor gnome-terminal gnome-tweak-tool nautilus

# fstab file

genfstab -U /mnt > /mnt/etc/fstab

# config

cp -r `dirname $0`/../arch /mnt/root
arch-chroot /mnt ~/arch/system2.sh
rm -rf /mnt/root/arch

# unmount

swapoff /dev/mapper/vg1-swap
umount -R /mnt

