set -e -o verbose

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

# root password

set +e

(exit 1)
while [[ ! $? == 0 ]]; do
  passwd
done

set -e

# normal user

useradd -m -g users -G wheel -s /bin/zsh greg

set +e

(exit 1)
while [[ ! $? == 0 ]]; do
  passwd greg
done

set -e

echo "greg ALL=(ALL) NOPASSWD: ALL" | sudo EDITOR="tee -a" visudo

# temp zsh profile

touch /home/greg/.zshrc
chown greg:users /home/greg/.zshrc

# firmware

su greg --command ". `dirname $0`/system3.sh"

# new initramfs

cp `dirname $0`/etc/mkinitcpio.conf /etc
mkinitcpio -p linux

# pacman

reflector --country Poland --sort rate --save /etc/pacman.d/mirrorlist
sed -i 's/#Color/Color/g' /etc/pacman.conf

# scripts

su greg --command "mkdir ~/Code; git clone https://github.com/GrzegorzKozub/arch.git ~/Code/arch"

