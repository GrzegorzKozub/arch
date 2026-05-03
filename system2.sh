#!/usr/bin/env bash
set -eo pipefail -ux

# timezone

ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc

# localization

sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/#pl_PL.UTF-8 UTF-8/pl_PL.UTF-8 UTF-8/' /etc/locale.gen

locale-gen

cp "${BASH_SOURCE%/*}"/etc/locale.conf /etc

# hostname

echo "$MY_HOSTNAME" > /etc/hostname

# hosts

sed -i \
  -e "/.*localhost.*/d" \
  -e "/.*localdomain.*/d" \
  /etc/hosts

{
  echo '127.0.0.1 localhost'
  echo '::1       localhost'
  echo "127.0.0.1 $MY_HOSTNAME.localdomain $MY_HOSTNAME"
  echo "::1       $MY_HOSTNAME.localdomain $MY_HOSTNAME"
} >> /etc/hosts

# global host environment variable

echo "HOST=$MY_HOSTNAME" >> /etc/environment

# root password

set +e

(exit 1)
# shellcheck disable=SC2181
while [[ ! $? == 0 ]]; do
  passwd
done

set -e

# normal user

useradd -m -g users -G wheel,realtime -s /bin/zsh greg

set +e

(exit 1)
# shellcheck disable=SC2181
while [[ ! $? == 0 ]]; do
  passwd greg
done

set -e

echo 'greg ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo

# zsh env & temp profile

cp "${BASH_SOURCE%/*}"/etc/zsh/zshenv /etc/zsh

touch /home/greg/.zshrc
chown greg:users /home/greg/.zshrc

# increase the highest requested rtc interrupt frequency

cp "${BASH_SOURCE%/*}"/etc/tmpfiles.d/rtc.conf /etc/tmpfiles.d

# change systemd start & stop timeouts from 90 to 15 seconds

[[ -d /etc/systemd/system.conf.d ]] || mkdir /etc/systemd/system.conf.d
cp "${BASH_SOURCE%/*}"/etc/systemd/system.conf.d/00-timeout.conf /etc/systemd/system.conf.d

# ntp

[[ -d /etc/systemd/timesyncd.conf.d ]] || mkdir /etc/systemd/timesyncd.conf.d
cp "${BASH_SOURCE%/*}"/etc/systemd/timesyncd.conf.d/ntp.conf /etc/systemd/timesyncd.conf.d

# limit journal size to 64 MB

[[ -d /etc/systemd/journald.conf.d ]] || mkdir /etc/systemd/journald.conf.d
cp "${BASH_SOURCE%/*}"/etc/systemd/journald.conf.d/00-size.conf /etc/systemd/journald.conf.d

# limit journal entries

[[ -d /etc/systemd/system/rtkit-daemon.service.d ]] || mkdir -p /etc/systemd/system/rtkit-daemon.service.d
cp "${BASH_SOURCE%/*}"/etc/systemd/system/rtkit-daemon.service.d/log.conf /etc/systemd/system/rtkit-daemon.service.d

# performance optimization

cp "${BASH_SOURCE%/*}"/etc/sysctl.d/70-perf.conf /etc/sysctl.d
cp "${BASH_SOURCE%/*}"/etc/udev/rules.d/60-ioschedulers.rules /etc/udev/rules.d

# zram

# cp "${BASH_SOURCE%/*}"/etc/systemd/zram-generator.conf /etc/systemd
# cp "${BASH_SOURCE%/*}"/etc/sysctl.d/71-zram.conf /etc/sysctl.d
# cp "${BASH_SOURCE%/*}"/etc/udev/rules.d/30-zram.rules /etc/udev/rules.d

# amd chipset

[[ $MY_HOSTNAME =~ ^(player|worker)$ ]] &&
  cp "${BASH_SOURCE%/*}"/etc/modprobe.d/amd.conf /etc/modprobe.d

# intel chipset

[[ $MY_HOSTNAME == 'drifter' ]] &&
  cp "${BASH_SOURCE%/*}"/etc/modprobe.d/intel.conf /etc/modprobe.d

# nvidia gpu

if [[ $MY_HOSTNAME =~ ^(player|worker)$ ]]; then

  cp "${BASH_SOURCE%/*}"/etc/modprobe.d/nvidia.conf /etc/modprobe.d

  # enable/disable runtime power management for nvidia on driver bind/unbind
  # cp "${BASH_SOURCE%/*}"/etc/udev/rules.d/71-nvidia.rules /etc/udev/rules.d

  # enable nvidia overclocking
  cp "${BASH_SOURCE%/*}"/etc/X11/xorg.conf.d/20-nvidia.conf /etc/X11/xorg.conf.d

  # disable rootless xorg to allow nvidia overclocking
  # cp `dirname $0`/etc/X11/Xwrapper.config /etc/X11

fi

# webcam

SOURCE="${BASH_SOURCE%/*}"/etc/udev/rules.d/90-webcam.$MY_HOSTNAME.rules
[[ -f $SOURCE ]] && cp "$SOURCE" /etc/udev/rules.d/90-webcam.rules

# sleep fixes

[[ $MY_HOSTNAME =~ ^(player|worker)$ ]] &&
  cp "${BASH_SOURCE%/*}"/etc/tmpfiles.d/wakeup.conf /etc/tmpfiles.d

# laptop power saving

if [[ $MY_HOSTNAME == 'drifter' ]]; then

  cp "${BASH_SOURCE%/*}"/etc/modprobe.d/laptop.conf /etc/modprobe.d
  cp "${BASH_SOURCE%/*}"/etc/sysctl.d/80-laptop.conf /etc/sysctl.d

fi

# auditd

sed -i 's/num_logs.*/num_logs = 8/' /etc/audit/auditd.conf

# apparmor

# sed -i \
#   -e 's/#write-cache/write-cache/' \
#   -e 's/#Optimize=compress-fast/Optimize=compress-fast/' \
#   /etc/apparmor/parser.conf

# wifi regulatory domain

sed -i 's/#WIRELESS_REGDOM="PL"/WIRELESS_REGDOM="PL"/' /etc/conf.d/wireless-regdom

# always mount data

[[ -d /run/media/greg/data ]] || mkdir -p /run/media/greg/data

echo '/dev/mapper/vg1-data	/run/media/greg/data	ext4	defaults,noatime	0 2' >> /etc/fstab
echo '' >> /etc/fstab

"${BASH_SOURCE%/*}"/fstab.sh

# reflector

sed -Ei 's/^\# --country.+$/--country Poland,Germany/' /etc/xdg/reflector/reflector.conf
sed -Ei 's/^\--latest.+$/--latest 10/' /etc/xdg/reflector/reflector.conf
sed -Ei 's/^\--sort.+$/--sort rate/' /etc/xdg/reflector/reflector.conf

reflector --save /etc/pacman.d/mirrorlist --protocol https --country Poland,Germany --latest 10 --sort rate

# pacman

sed -i 's/#Color/Color/' /etc/pacman.conf

sed -i 's/^OPTIONS=\(.*\) debug\(.*\)$/OPTIONS=\1 !debug\2/' /etc/makepkg.conf
sed -i "s/^PKGEXT='.pkg.tar.zst'\$/PKGEXT='.pkg.tar'/" /etc/makepkg.conf

# cachyos repos - https://wiki.cachyos.org/features/optimized_repos/#adding-our-repositories-to-an-existing-arch-linux-install

curl -O https://mirror.cachyos.org/cachyos-repo.tar.xz
tar xvf cachyos-repo.tar.xz
cd cachyos-repo && ./cachyos-repo.sh && cd ..
rm -rf cachyos-repo cachyos-repo.tar.xz

pacman -Syu --noconfirm

# continue as regular user

cp "${BASH_SOURCE%/*}"/system3.sh /home/greg
# shellcheck disable=SC2088
su greg --command '~/system3.sh'
rm /home/greg/system3.sh

# virtual console (before mkinitcpio)

cp "${BASH_SOURCE%/*}"/etc/vconsole.conf /etc

# busybox based initial ramdisk (before mkinitcpio)

# sed -Ei \
#   's/^HOOKS=.+$/HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt lvm2 resume filesystems fsck)/' \
#   /etc/mkinitcpio.conf

# systemd based initial ramdisk (before mkinitcpio)

sed -Ei \
  's/^HOOKS=.+$/HOOKS=(base systemd autodetect microcode modconf kms keyboard sd-vconsole block sd-encrypt lvm2 filesystems fsck)/' \
  /etc/mkinitcpio.conf

  # plymouth (splash, after systemd)

# limine (before mkinitcpio)

[[ -d /etc/pacman.d/hooks ]] || mkdir -p /etc/pacman.d/hooks
cp "${BASH_SOURCE%/*}"/etc/pacman.d/hooks/91-limine.hook /etc/pacman.d/hooks/

# dm-crypt with systemd based initial ramdisk (before mkinitcpio)

cp "${BASH_SOURCE%/*}"/etc/crypttab.initramfs /etc
sed -i \
  "s/<uuid>/$(blkid -s UUID -o value "$MY_ARCH_PART")/g" \
  /etc/crypttab.initramfs

# initial ramdisk

mkinitcpio -p linux
mkinitcpio -p linux-lts

# scripts

su greg --command 'mkdir ~/code; git clone https://github.com/GrzegorzKozub/arch.git ~/code/arch'
