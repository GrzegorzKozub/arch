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

echo "greg ALL=(ALL:ALL) ALL" | sudo EDITOR="tee -a" visudo

# initial zsh profile

touch /home/greg/.zshrc
chown greg:users /home/greg/.zshrc

# scripts

su greg --command "mkdir ~/Code; git clone https://github.com/GrzegorzKozub/Arch.git ~/Code/Arch"

