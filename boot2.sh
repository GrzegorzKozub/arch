#!/usr/bin/env bash

set -e -o verbose

# boot manager

bootctl --path=/boot install

cp `dirname $0`/boot/loader/loader.conf /boot/loader
cp `dirname $0`/boot/loader/entries/*.conf /boot/loader/entries

sed -i "s/<uuid>/$(blkid -s UUID -o value $MY_ARCH_PART)/g" /boot/loader/entries/*.conf

if [[ $MY_HOSTNAME = 'ampere' ]]; then
  sed -i "s/<ucode>/amd-ucode/g" /boot/loader/entries/*.conf
  sed -i "s/<kernel_params>//g" /boot/loader/entries/*.conf
fi

if [[ $MY_HOSTNAME = 'drifter' ]]; then
  sed -i "s/<ucode>/intel-ucode/g" /boot/loader/entries/*.conf
  sed -i "s/<kernel_params>/video=1280x800 /g" /boot/loader/entries/*.conf
fi

if [[ $MY_HOSTNAME = 'turing' ]]; then
  sed -i "s/<ucode>/intel-ucode/g" /boot/loader/entries/*.conf
  sed -i "s/<kernel_params>//g" /boot/loader/entries/*.conf
fi

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

unset WINDOWS LINUX

