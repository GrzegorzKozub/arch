#!/usr/bin/env bash

set -e -o verbose

# boot manager

bootctl --path=/boot install

cp `dirname $0`/boot/loader/loader.conf /boot/loader
cp `dirname $0`/boot/loader/entries/*.conf /boot/loader/entries

# cryptdevice

sed -i "s/<uuid>/$(blkid -s UUID -o value $MY_ARCH_PART)/g" /boot/loader/entries/*.conf

# initrd cpu ucode image

[[ $MY_HOSTNAME = 'drifter' || $MY_HOSTNAME = 'worker' ]] && sed -i 's/<ucode>/intel-ucode/g' /boot/loader/entries/*.conf
[[ $MY_HOSTNAME = 'player' ]] && sed -i 's/<ucode>/amd-ucode/g' /boot/loader/entries/*.conf

# fix refresh rates above 60 hz over hdmi broken by nvidia 550 and allow 10 bit color

[[ $MY_HOSTNAME = 'player' ]] && sed -i 's/<kernel_params>/nvidia_modeset.hdmi_deepcolor=1 /g' /boot/loader/entries/*.conf

# required for wayland on nvidia and removes unknown display from gnome but breaks undervolting

# [[ $MY_HOSTNAME = 'player' ]] && sed -i 's/<kernel_params>/nvidia_modeset.hdmi_deepcolor=1 nvidia-drm.modeset=1 /g' /boot/loader/entries/*.conf

# force s3 sleep (https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Changing_suspend_method)

# [[ $MY_HOSTNAME = 'drifter' ]] && sed -i 's/<kernel_params>/mem_sleep_default=deep /g' /boot/loader/entries/*.conf

# remaining kernel_params placeholder

sed -i 's/<kernel_params>//g' /boot/loader/entries/*.conf

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

