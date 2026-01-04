#!/usr/bin/env bash

set -e -o verbose

# systemd-boot deployment to esp & config init

bootctl --path=/boot install

cp $(dirname $0)/boot/loader/loader.conf /boot/loader
cp $(dirname $0)/boot/loader/entries/*.conf /boot/loader/entries

[[ $MY_HOSTNAME = 'drifter' ]] &&
  sed -i 's/^reboot-for-bitlocker no$/reboot-for-bitlocker yes/' /boot/loader/loader.conf

# limine deployment to esp & config init

[[ -d /boot/EFI/limine ]] || mkdir -p /boot/EFI/limine
cp /usr/share/limine/BOOTX64.EFI /boot/EFI/limine/

cp $(dirname $0)/boot/EFI/limine/limine.conf /boot/EFI/limine/

# ucode

[[ $MY_HOSTNAME = 'drifter' ]] &&
  sed -i 's/<ucode>/intel-ucode/g' /boot/loader/entries/*.conf /boot/EFI/limine/limine.conf

[[ $MY_HOSTNAME =~ ^(player|worker)$ ]] &&
  sed -i 's/<ucode>/amd-ucode/g' /boot/loader/entries/*.conf /boot/EFI/limine/limine.conf

# dm-crypt with busybox based initial ramdisk

# sed -i \
#   "s/<params>/cryptdevice=UUID=$(blkid -s UUID -o value $MY_ARCH_PART):vg1:allow-discards <params>/g" \
#   /boot/loader/entries/*.conf /boot/EFI/limine/limine.conf

# enable amd p-state in active mode (amd_pstate_epp driver)

[[ $MY_HOSTNAME =~ ^(player|worker)$ ]] &&
  sed -i 's/<params>/amd_pstate=active <params>/g' /boot/loader/entries/*.conf /boot/EFI/limine/limine.conf

# enable kernel mode setting (kms) for nvidia (required for gdm to start rootless xorg & for wayland)

[[ $MY_HOSTNAME =~ ^(player|worker)$ ]] &&
  sed -i 's/<params>/nvidia-drm.modeset=1 <params>/g' /boot/loader/entries/*.conf /boot/EFI/limine/limine.conf

# force s3 sleep (https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Changing_suspend_method)

# [[ $MY_HOSTNAME = 'drifter' ]] &&
#   sed -i 's/<params>/mem_sleep_default=deep <params>/g' /boot/loader/entries/*.conf /boot/EFI/limine/limine.conf

# enable rcu lazy to save power

[[ $MY_HOSTNAME = 'drifter' ]] &&
  sed -i 's/<params>/rcutree.enable_rcu_lazy=1 <params>/g' /boot/loader/entries/*.conf /boot/EFI/limine/limine.conf

# silent boot

sed -i 's/<params>/quiet loglevel=3 rd.udev.log_level=3 <params>/g' /boot/loader/entries/*.conf /boot/EFI/limine/limine.conf

# auditd

# sed -i 's/<params>/audit=1 <params>/g' /boot/loader/entries/*.conf /boot/EFI/limine/limine.conf

# apparmor

# sed -i 's/<params>/lsm=landlock,lockdown,yama,integrity,apparmor,bpf <params>/g' /boot/loader/entries/*.conf /boot/EFI/limine/limine.conf

# splash

# sed -i 's/<params>/splash <params>/g' /boot/loader/entries/*.conf /boot/EFI/limine/limine.conf

# remove kernel params placeholder

sed -i 's/ <params>//g' /boot/loader/entries/*.conf /boot/EFI/limine/limine.conf

# secure boot support for systemd-boot using PreLoader

cp $(dirname $0)/boot3.zsh /home/greg
su greg --command '~/boot3.zsh'
rm /home/greg/boot3.zsh

cp /usr/share/preloader-signed/{PreLoader,HashTool}.efi /boot/EFI/systemd
cp /boot/EFI/systemd/systemd-bootx64.efi /boot/EFI/systemd/loader.efi

cp $(dirname $0)/boot4.zsh /home/greg
su greg --command '~/boot4.zsh'
rm /home/greg/boot4.zsh

# systemd-boot efi boot menu item using PreLoader

BOOTNUM=$(efibootmgr | grep 'systemd-boot' | awk '{print $1}' | grep -o '[0-9]*')
[[ $BOOTNUM ]] && efibootmgr --delete-bootnum --bootnum "$BOOTNUM"

efibootmgr --create --label 'systemd-boot' \
  --disk $MY_DISK --part $MY_EFI_PART_NBR --loader /EFI/systemd/PreLoader.efi

# limine efi boot menu item

BOOTNUM=$(efibootmgr | grep 'limine' | awk '{print $1}' | grep -o '[0-9]*')
[[ $BOOTNUM ]] && efibootmgr --delete-bootnum --bootnum "$BOOTNUM"

efibootmgr --create --label 'limine' \
  --disk $MY_DISK --part $MY_EFI_PART_NBR --loader /EFI/limine/liminex64.efi \
  --unicode
