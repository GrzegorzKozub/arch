#!/usr/bin/env bash

set -e -o verbose

# timezone

ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc

# localization

sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/#pl_PL.UTF-8 UTF-8/pl_PL.UTF-8 UTF-8/' /etc/locale.gen

locale-gen

cp $(dirname $0)/etc/locale.conf /etc

# hostname

echo $MY_HOSTNAME > /etc/hostname

# hosts

sed -i -e "/.*localhost.*/d" /etc/hosts

echo '127.0.0.1 localhost' >> /etc/hosts
echo '::1       localhost' >> /etc/hosts
echo "127.0.0.1 $MY_HOSTNAME.localdomain $MY_HOSTNAME" >> /etc/hosts
echo "::1       $MY_HOSTNAME.localdomain $MY_HOSTNAME" >> /etc/hosts

# global host environment variable

echo "HOST=$MY_HOSTNAME" >> /etc/environment

# root password

set +e

(exit 1)
while [[ ! $? = 0 ]]; do
  passwd
done

set -e

# normal user

useradd -m -g users -G wheel,realtime -s /bin/zsh greg

set +e

(exit 1)
while [[ ! $? = 0 ]]; do
  passwd greg
done

set -e

echo 'greg ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo

# temp zsh profile

touch /home/greg/.zshrc
chown greg:users /home/greg/.zshrc

# increase the highest requested rtc interrupt frequency

cp $(dirname $0)/etc/tmpfiles.d/rtc.conf /etc/tmpfiles.d

# only keep coredumps from last 3 days

cp $(dirname $0)/etc/tmpfiles.d/coredump.conf /etc/tmpfiles.d

# change systemd start & stop timeouts from 90 to 15 seconds

[[ -d /etc/systemd/system.conf.d ]] || mkdir /etc/systemd/system.conf.d
cp $(dirname $0)/etc/systemd/system.conf.d/00-timeout.conf /etc/systemd/system.conf.d

# ntp

[[ -d /etc/systemd/timesyncd.conf.d ]] || mkdir /etc/systemd/timesyncd.conf.d
cp $(dirname $0)/etc/systemd/timesyncd.conf.d/ntp.conf /etc/systemd/timesyncd.conf.d

# limit journal size to 64 MB

[[ -d /etc/systemd/journald.conf.d ]] || mkdir /etc/systemd/journald.conf.d
cp $(dirname $0)/etc/systemd/journald.conf.d/00-size.conf /etc/systemd/journald.conf.d

# limit journal entries

[[ -d /etc/systemd/system/rtkit-daemon.service.d ]] || mkdir -p /etc/systemd/system/rtkit-daemon.service.d
cp $(dirname $0)/etc/systemd/system/rtkit-daemon.service.d/log.conf /etc/systemd/system/rtkit-daemon.service.d

# zram

# cp $(dirname $0)/etc/systemd/zram-generator.conf /etc/systemd
# cp $(dirname $0)/etc/udev/rules.d/20-zram.rules /etc/udev/rules.d

# performance optimization

cp $(dirname $0)/etc/sysctl.d/70-perf.conf /etc/sysctl.d
cp $(dirname $0)/etc/udev/rules.d/60-ioschedulers.rules /etc/udev/rules.d

# nvidia gpu

if [[ $MY_HOSTNAME =~ ^(player|worker)$ ]]; then

  cp $(dirname $0)/etc/modprobe.d/nvidia.conf /etc/modprobe.d

  # enable/disable runtime power management for nvidia on driver bind/unbind
  # cp $(dirname $0)/etc/udev/rules.d/71-nvidia.rules /etc/udev/rules.d

  # enable nvidia overclocking
  cp $(dirname $0)/etc/X11/xorg.conf.d/20-nvidia.conf /etc/X11/xorg.conf.d

  # disable rootless xorg to allow nvidia overclocking
  # cp `dirname $0`/etc/X11/Xwrapper.config /etc/X11

fi

# webcam video format

[[ $MY_HOSTNAME = 'worker' ]] &&
  cp $(dirname $0)/etc/udev/rules.d/10-c922.rules /etc/udev/rules.d

# sleep fixes

[[ $MY_HOSTNAME =~ ^(player|worker)$ ]] &&
  cp $(dirname $0)/etc/tmpfiles.d/wakeup.conf /etc/tmpfiles.d

# laptop power saving

if [[ $MY_HOSTNAME = 'drifter' ]]; then

  echo 'options snd_hda_intel power_save=1' > /etc/modprobe.d/laptop-power.conf
  echo 'options iwlwifi power_save=1' > /etc/modprobe.d/laptop-power.conf
  echo 'vm.dirty_writeback_centisecs = 6000' > /etc/sysctl.d/laptop-power.conf

fi

# always mount data

[[ -d /run/media/greg/data ]] || mkdir -p /run/media/greg/data

echo '/dev/mapper/vg1-data	/run/media/greg/data	ext4	defaults,noatime	0 2' >> /etc/fstab
echo '' >> /etc/fstab

$(dirname $0)/fstab.sh

# reflector

sed -Ei 's/^\# --country.+$/--country Poland,Germany/' /etc/xdg/reflector/reflector.conf
sed -Ei 's/^\--latest.+$/--latest 10/' /etc/xdg/reflector/reflector.conf
sed -Ei 's/^\--sort.+$/--sort rate/' /etc/xdg/reflector/reflector.conf

reflector --save /etc/pacman.d/mirrorlist --protocol https --country Poland,Germany --latest 10 --sort rate

# pacman

sed -i 's/#Color/Color/' /etc/pacman.conf

sed -i 's/^OPTIONS=\(.*\) debug\(.*\)$/OPTIONS=\1 !debug\2/' /etc/makepkg.conf
sed -i "s/^PKGEXT='.pkg.tar.zst'\$/PKGEXT='.pkg.tar'/" /etc/makepkg.conf

# disable mkinitcpio pacman hook

# DIR=/etc/pacman.d/hooks
# [[ -d $DIR ]] || mkdir -p $DIR
# ln -sf /dev/null $DIR/90-mkinitcpio-install.hook

# continue as regular user

cp $(dirname $0)/system3.zsh /home/greg
su greg --command '~/system3.zsh'
rm /home/greg/system3.zsh

# restore mkinitcpio pacman hook

# rm -f $DIR/90-mkinitcpio-install.hook

# virtual console (before mkinitcpio)

cp $(dirname $0)/etc/vconsole.conf /etc

# busybox based initial ramdisk (before mkinitcpio)

# sed -Ei \
#   's/^HOOKS=.+$/HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt lvm2 resume filesystems fsck)/' \
#   /etc/mkinitcpio.conf

# systemd based initial ramdisk (before mkinitcpio)

sed -Ei \
  's/^HOOKS=.+$/HOOKS=(base systemd autodetect microcode modconf kms keyboard sd-vconsole block sd-encrypt lvm2 filesystems fsck)/' \
  /etc/mkinitcpio.conf

# plymouth (splash, after systemd)

# dm-crypt with systemd based initial ramdisk (before mkinitcpio)

cp $(dirname $0)/etc/crypttab.initramfs /etc
sed -i \
  "s/<uuid>/$(blkid -s UUID -o value $MY_ARCH_PART)/g" \
  /etc/crypttab.initramfs

# initial ramdisk

mkinitcpio -p linux
mkinitcpio -p linux-lts

# scripts

su greg --command 'mkdir ~/code; git clone https://github.com/GrzegorzKozub/arch.git ~/code/arch'
