#!/usr/bin/env bash

set -e -o verbose

# boot manager

bootctl --path=/boot install

cp $(dirname $0)/boot/loader/loader.conf /boot/loader
cp $(dirname $0)/boot/loader/entries/*.conf /boot/loader/entries

[[ $MY_HOSTNAME = 'drifter' ]] &&
  sed -i 's/^reboot-for-bitlocker no$/reboot-for-bitlocker yes/' /boot/loader/loader.conf

# ucode

[[ $MY_HOSTNAME = 'drifter' ]] &&
  sed -i 's/<ucode>/intel-ucode/g' /boot/loader/entries/*.conf

[[ $MY_HOSTNAME =~ ^(player|worker)$ ]] &&
  sed -i 's/<ucode>/amd-ucode/g' /boot/loader/entries/*.conf

# dm-crypt with busybox based initial ramdisk

# sed -i \
#   "s/<params>/cryptdevice=UUID=$(blkid -s UUID -o value $MY_ARCH_PART):vg1:allow-discards <params>/g" \
#   /boot/loader/entries/*.conf

# enable amd p-state in active mode (amd_pstate_epp driver)

[[ $MY_HOSTNAME =~ ^(player|worker)$ ]] &&
  sed -i 's/<params>/amd_pstate=active <params>/g' /boot/loader/entries/*.conf

# enable kernel mode setting (kms) for nvidia (required for gdm to start rootless xorg & for wayland)

[[ $MY_HOSTNAME =~ ^(player|worker)$ ]] &&
  sed -i 's/<params>/nvidia-drm.modeset=1 <params>/g' /boot/loader/entries/*.conf

# force s3 sleep (https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Changing_suspend_method)

# [[ $MY_HOSTNAME = 'drifter' ]] &&
#   sed -i 's/<params>/mem_sleep_default=deep <params>/g' /boot/loader/entries/*.conf

# enable rcu lazy to save power

[[ $MY_HOSTNAME = 'drifter' ]] &&
  sed -i 's/<params>/rcutree.enable_rcu_lazy=1 <params>/g' /boot/loader/entries/*.conf

# silent boot

sed -i 's/<params>/quiet loglevel=3 rd.udev.log_level=3 <params>/g' /boot/loader/entries/*.conf

# apparmor

sed -i 's/<params>/lsm=landlock,lockdown,yama,integrity,apparmor,bpf <params>/g' /boot/loader/entries/*.conf

# splash

# sed -i 's/<params>/splash <params>/g' /boot/loader/entries/*.conf

# remove kernel params placeholder

sed -i 's/ <params>//g' /boot/loader/entries/*.conf

# secure boot support using PreLoader

cp $(dirname $0)/boot3.zsh /home/greg
su greg --command '~/boot3.zsh'
rm /home/greg/boot3.zsh

cp /usr/share/preloader-signed/{PreLoader,HashTool}.efi /boot/EFI/systemd
cp /boot/EFI/systemd/systemd-bootx64.efi /boot/EFI/systemd/loader.efi

cp $(dirname $0)/boot4.zsh /home/greg
su greg --command '~/boot4.zsh'
rm /home/greg/boot4.zsh

# efi boot menu using PreLoader

for BOOTNUM in $(efibootmgr | grep 'Linux Boot Manager' | sed -E 's/^Boot(.+)\* Linux.*$/\1/'); do
  efibootmgr --delete-bootnum --bootnum $BOOTNUM
done

efibootmgr --disk $MY_DISK --part $MY_EFI_PART_NBR --create --label 'Linux Boot Manager' --loader /EFI/systemd/PreLoader.efi
