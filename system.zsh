#!/usr/bin/env zsh

set -e -o verbose

# validation

EFI_PART="$(
  lsblk -lno PATH,PARTTYPE,FSTYPE |
  grep -i 'c12a7328-f81f-11d2-ba4b-00a0c93ec93b' |
  grep 'vfat' |
  cut -d' ' -f1
)"

[[ $MY_HOSTNAME ]] || exit 1
[[ $MY_EFI_PART && $EFI_PART = $MY_EFI_PART ]] || exit 1

# time sync

timedatectl set-ntp true

# internet

ping -c 1 8.8.8.8 || exit 1

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
  /mnt/boot/initramfs-linux-lts.img \
  /mnt/boot/initramfs-linux-lts-fallback.img \
  /mnt/boot/amd-ucode.img \
  /mnt/boot/intel-ucode.img \
  /mnt/boot/vmlinuz-linux \
  /mnt/boot/vmlinuz-linux-lts
do
  [[ -f $FILE ]] && rm $FILE
done

# operating system

pacstrap /mnt \
  base base-devel \
  linux linux-lts linux-firmware \
  terminus-font \
  efibootmgr sbctl \
  tpm2-tss \
  fwupd \
  lvm2 \
  ntfs-3g \
  avahi nss-mdns \
  lm_sensors \
  v4l-utils \
  networkmanager \
  usbutils bluez-utils v4l-utils \
  pipewire pipewire-alsa pipewire-pulse wireplumber \
  realtime-privileges \
  gst-plugins-good \
  xdg-desktop-portal xdg-utils \
  qt5-wayland \
  pacman-contrib \
  git go pkgfile reflector sudo zsh \
  man-db man-pages \
  xorg-server \
  gdm glib2-devel \
  argyllcms

  # nftables plymouth (splash)

# fstab

genfstab -U /mnt > /mnt/etc/fstab

sed -i \
  -e "s/ext4      	rw,relatime/ext4      	rw,noatime/" \
  -e "s/fmask=0022/fmask=0077/" \
  -e "s/dmask=0022/dmask=0077/" \
  /etc/fstab

# continue as root

cp -r `dirname $0`/../arch /mnt/root
arch-chroot /mnt ~/arch/system2.sh
rm -rf /mnt/root/arch

# unmount

swapoff /dev/mapper/vg1-swap
umount -R /mnt

