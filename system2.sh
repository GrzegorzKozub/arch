set -o verbose

# timezone

ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc

# localization

cp `dirname $0`/etc/locale.gen /etc
locale-gen
cp `dirname $0`/etc/locale.conf /etc
cp `dirname $0`/etc/vconsole.conf /etc

# network

cp `dirname $0`/etc/hostname /etc
cp `dirname $0`/etc/hosts /etc

# new initramfs

cp `dirname $0`/etc/mkinitcpio.conf /etc
mkinitcpio -p linux

# pacman mirror list

reflector --country Poland --sort rate --save /etc/pacman.d/mirrorlist

# root password

(exit 1)
while [[ ! $? == 0 ]]; do
  passwd
done

# normal user

useradd -m -g users -G wheel -s /bin/zsh greg
(exit 1)
while [[ ! $? == 0 ]]; do
  passwd greg
done
read -p "Copy root settings for the normal user and exit writing the file"
EDITOR=nano visudo

# TODO: make part of boot.sh and fix permissions for normal user

mkdir /home/greg/Code
cp -r /root/Arch /home/greg/Code

