#!/usr/bin/env bash

set -e -o verbose

# boot manager

bootctl --path=/boot install

cp `dirname $0`/boot/loader/loader.conf /boot/loader
cp `dirname $0`/boot/loader/entries/*.conf /boot/loader/entries

# ucode

[[ $MY_HOSTNAME =~ ^(drifter|worker)$ ]] &&
  sed -i 's/<ucode>/intel-ucode/g' /boot/loader/entries/*.conf

[[ $MY_HOSTNAME = 'player' ]] &&
  sed -i 's/<ucode>/amd-ucode/g' /boot/loader/entries/*.conf

# dm-crypt with busybox based initial ramdisk

# sed -i \
#   "s/<params>/cryptdevice=UUID=$(blkid -s UUID -o value $MY_ARCH_PART):vg1:allow-discards <params>/g" \
#   /boot/loader/entries/*.conf

# enable amd p-state in active mode (amd_pstate_epp driver)

[[ $MY_HOSTNAME = 'player' ]] &&
  sed -i 's/<params>/amd_pstate=active <params>/g' /boot/loader/entries/*.conf

# enable kernel mode setting (kms) for nvidia (required for gdm to start rootless xorg & for wayland)

[[ $MY_HOSTNAME = 'player' ]] &&
  sed -i 's/<params>/nvidia-drm.modeset=1 <params>/g' /boot/loader/entries/*.conf

# force s3 sleep (https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Changing_suspend_method)

# [[ $MY_HOSTNAME = 'drifter' ]] &&
#   sed -i 's/<params>/mem_sleep_default=deep <params>/g' /boot/loader/entries/*.conf

# remove kernel params placeholder

sed -i 's/ <params>//g' /boot/loader/entries/*.conf

# secure boot support

cp `dirname $0`/boot3.zsh /home/greg
su greg --command '~/boot3.zsh'
rm /home/greg/boot3.zsh

cp /usr/share/preloader-signed/{PreLoader,HashTool}.efi /boot/EFI/systemd
cp /boot/EFI/systemd/systemd-bootx64.efi /boot/EFI/systemd/loader.efi

# efi boot menu

for BOOTNUM in $(efibootmgr | grep 'Linux Boot Manager' | sed -E 's/^Boot(.+)\* Linux.*$/\1/'); do
  efibootmgr --delete-bootnum --bootnum $BOOTNUM
done

efibootmgr --disk $MY_DISK --part $MY_EFI_PART_NBR --create --label 'Linux Boot Manager' --loader /EFI/systemd/PreLoader.efi

WINDOWS=$(efibootmgr | grep 'Windows Boot Manager' | head -n1 | sed -E 's/^Boot(.+)\* Windows Boot Manager$/\1/')
LINUX=$(efibootmgr | grep 'Linux Boot Manager' | sed -E 's/^Boot(.+)\* Linux Boot Manager$/\1/')

efibootmgr --bootorder $WINDOWS,$LINUX

