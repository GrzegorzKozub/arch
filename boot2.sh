#!/usr/bin/env bash

set -e -o verbose

# systemd-boot on esp

bootctl --path=/boot install

cp $(dirname $0)/boot/loader/loader.conf /boot/loader
cp $(dirname $0)/boot/loader/entries/*.conf /boot/loader/entries

# limine on esp

[[ -d /boot/EFI/limine ]] || mkdir -p /boot/EFI/limine
cp /usr/share/limine/BOOTX64.EFI /boot/EFI/limine/liminex64.efi

cp $(dirname $0)/boot/EFI/limine/limine.conf /boot/EFI/limine

wget -O /boot/EFI/limine/wall.jpg 'https://github.com/GrzegorzKozub/walls/blob/master/women.jpg?raw=true'

[[ $MY_HOSTNAME = 'worker' ]] ||
  sed -i '/^interface_resolution.*/d' /boot/EFI/limine/limine.conf

sed -i "s/<host>/$MY_HOSTNAME/g" /boot/EFI/limine/limine.conf

[[ $MY_HOSTNAME = 'drifter' ]] &&
  sed -i 's/<font>/3x3/g' /boot/EFI/limine/limine.conf

[[ $MY_HOSTNAME =~ ^(player|worker)$ ]] &&
  sed -i 's/<font>/2x2/g' /boot/EFI/limine/limine.conf

# bitlocker

[[ $MY_HOSTNAME = 'drifter' ]] &&
  sed -i 's/^reboot-for-bitlocker no$/reboot-for-bitlocker yes/' /boot/loader/loader.conf

  # https://codeberg.org/Limine/Limine/issues/12

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

# auditd

# sed -i 's/<params>/audit=1 <params>/g' /boot/loader/entries/*.conf /boot/EFI/limine/limine.conf

# apparmor

# sed -i 's/<params>/lsm=landlock,lockdown,yama,integrity,apparmor,bpf <params>/g' /boot/loader/entries/*.conf /boot/EFI/limine/limine.conf

# silent boot

sed -i 's/<params>/quiet loglevel=3 rd.udev.log_level=3 <params>/g' /boot/loader/entries/*.conf /boot/EFI/limine/limine.conf

# splash

# sed -i 's/<params>/splash <params>/g' /boot/loader/entries/*.conf /boot/EFI/limine/limine.conf

# remove kernel params placeholder

sed -i 's/ <params>//g' /boot/loader/entries/*.conf /boot/EFI/limine/limine.conf

# systemd-boot efi boot menu item

BOOTNUM=$(efibootmgr | grep 'systemd-boot' | awk '{print $1}' | grep -o '[0-9]*' || true)
[[ $BOOTNUM ]] && efibootmgr --delete-bootnum --bootnum "$BOOTNUM"

efibootmgr --create --label 'systemd-boot' \
  --disk "$MY_DISK" --part "$MY_EFI_PART_NBR" --loader /EFI/systemd/systemd-bootx64.efi

# limine efi boot menu item

BOOTNUM=$(efibootmgr | grep 'limine' | awk '{print $1}' | grep -o '[0-9]*' || true)
[[ $BOOTNUM ]] && efibootmgr --delete-bootnum --bootnum "$BOOTNUM"

efibootmgr --create --label 'limine' \
  --disk "$MY_DISK" --part "$MY_EFI_PART_NBR" --loader /EFI/limine/liminex64.efi \
  --unicode

# systemd-boot secure boot support using preloader

cp $(dirname $0)/preloader.sh /home/greg
su greg --command '~/preloader.sh enable'
rm /home/greg/preloader.sh
