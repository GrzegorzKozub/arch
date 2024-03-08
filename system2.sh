#!/usr/bin/env bash

set -e -o verbose

# timezone

ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc

# localization

sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/#pl_PL.UTF-8 UTF-8/pl_PL.UTF-8 UTF-8/' /etc/locale.gen

locale-gen

echo 'LANG=en_US.UTF-8' > /etc/locale.conf
echo 'LC_MEASUREMENT=pl_PL.UTF-8' >> /etc/locale.conf
echo 'LC_MONETARY=pl_PL.UTF-8' >> /etc/locale.conf
echo 'LC_NUMERIC=pl_PL.UTF-8' >> /etc/locale.conf
echo 'LC_PAPER=pl_PL.UTF-8' >> /etc/locale.conf
echo 'LC_TIME=pl_PL.UTF-8' >> /etc/locale.conf

if [[ $MY_HOSTNAME = 'drifter' ]]; then
  echo 'FONT=ter-232b' >> /etc/vconsole.conf
else
  echo 'FONT=ter-216b' >> /etc/vconsole.conf
fi

echo 'FONT_MAP=8859-2' >> /etc/vconsole.conf
echo 'KEYMAP=pl2' > /etc/vconsole.conf

# network

echo $MY_HOSTNAME > /etc/hostname

echo '127.0.0.1 localhost' >> /etc/hosts
echo '::1       localhost' >> /etc/hosts
echo "127.0.0.1 $MY_HOSTNAME.localdomain $MY_HOSTNAME" >> /etc/hosts
echo "::1       $MY_HOSTNAME.localdomain $MY_HOSTNAME" >> /etc/hosts

sed -i 's/myhostname resolve/myhostname mdns_minimal [NOTFOUND=return] resolve/' /etc/nsswitch.conf

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

useradd -m -g users -G wheel -s /bin/zsh greg

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

# sleep fixes

if [[ $MY_HOSTNAME = 'player' ]]; then

  # don't wake up immediately after going to sleep
  echo 'w /proc/acpi/wakeup - - - - GPP0' > /usr/lib/tmpfiles.d/wakeup.conf

  # don't wake up with usb keyboard or mouse
  # echo 'w /proc/acpi/wakeup - - - - XHC0' > /usr/lib/tmpfiles.d/wakeup.conf

fi

# don't wake up with usb mouse

# [[ $MY_HOSTNAME = 'player' ]] &&
#   cp `dirname $0`/etc/udev/rules.d/10-model-o-2.rules /etc/udev/rules.d/10-model-o-2.rules

# [[ $MY_HOSTNAME = 'worker' ]] &&
#   cp `dirname $0`/etc/udev/rules.d/10-model-o.rules /etc/udev/rules.d/10-model-o.rules

# webcam video format

[[ $MY_HOSTNAME = 'drifter' ]] &&
  cp `dirname $0`/etc/udev/rules.d/10-hd-3000.rules /etc/udev/rules.d/10-hd-3000.rules

[[ $MY_HOSTNAME = 'worker' ]] &&
  cp `dirname $0`/etc/udev/rules.d/10-c922.rules /etc/udev/rules.d/10-c922.rules

# drifter power saving

[[ $MY_HOSTNAME = 'drifter' ]] && . `dirname $0`/power.zsh

# continue

cp `dirname $0`/system3.zsh /home/greg
su greg --command '~/system3.zsh'
rm /home/greg/system3.zsh

# kernel hooks: consolefont, encrypt, lvm2 and resume

[[ $MY_HOSTNAME = 'drifter' ]] && sed -Ei 's/^MODULES=.+$/MODULES=(i915)/' /etc/mkinitcpio.conf

sed -Ei 's/^HOOKS=.+$/HOOKS=(base udev consolefont autodetect microcode modconf block encrypt lvm2 resume filesystems kms keyboard keymap fsck)/' /etc/mkinitcpio.conf

mkinitcpio -p linux
mkinitcpio -p linux-lts

# wayland disabled on nvidia

[[ $MY_HOSTNAME = 'player' ]] &&
  sed -Ei 's/^.+WaylandEnable=.+$/WaylandEnable=false/' /etc/gdm/custom.conf

# # wayland enabled on nvidia
#
# if [[ $MY_HOSTNAME = 'player' ]]; then
#
#   # forces wayland on nvidia in gdm
#   ln -s /dev/null /etc/udev/rules.d/61-gdm.rules
#
#   # preserves nvidia video memory during suspend
#   echo 'options nvidia NVreg_PreserveVideoMemoryAllocations=1 NVreg_TemporaryFilePath=/var/tmp' > /etc/modprobe.d/nvidia-power-management.conf
#
# fi

# reflector

sed -Ei 's/^\# --country.+$/--country Poland,Germany/' /etc/xdg/reflector/reflector.conf
sed -Ei 's/^\--latest.+$/--latest 10/' /etc/xdg/reflector/reflector.conf
sed -Ei 's/^\--sort.+$/--sort rate/' /etc/xdg/reflector/reflector.conf

reflector --save /etc/pacman.d/mirrorlist --protocol https --country Poland,Germany --latest 10 --sort rate

# pacman

sed -i 's/#Color/Color/' /etc/pacman.conf

sed -i "s/PKGEXT='.pkg.tar.zst'/PKGEXT='.pkg.tar'/" /etc/makepkg.conf

# always mount data

[[ -d /run/media/greg/data ]] || mkdir -p /run/media/greg/data

echo '# /dev/mapper/vg1-data' >> /etc/fstab
echo '/dev/mapper/vg1-data	/run/media/greg/data	ext4	defaults	0 2' >> /etc/fstab
echo '' >> /etc/fstab

# default sound over hdmi to primary monitor

if [[ $MY_HOSTNAME = 'worker' ]]; then

  sed -Ei 's/priority = 59/priority = 58/' /usr/share/pulseaudio/alsa-mixer/paths/hdmi-output-0.conf
  sed -Ei 's/priority = 58/priority = 59/' /usr/share/pulseaudio/alsa-mixer/paths/hdmi-output-1.conf

fi

# scripts

su greg --command 'mkdir ~/code; git clone https://github.com/GrzegorzKozub/arch.git ~/code/arch'

