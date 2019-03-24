set -o verbose

ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc

cp `dirname $0`/etc/locale.gen /etc
locale-gen
cp `dirname $0`/etc/locale.conf /etc
cp `dirname $0`/etc/vconsole.conf /etc

cp `dirname $0`/etc/hostname /etc
cp `dirname $0`/etc/hosts /etc

cp `dirname $0`/etc/mkinitcpio.conf /etc
mkinitcpio -p linux

(exit 1)
while [[ ! $? == 0 ]]; do
  passwd
done

useradd -m -g users -G wheel -s /bin/zsh greg
(exit 1)
while [[ ! $? == 0 ]]; do
  passwd greg
done
read -p "Copy root settings for normal user and exit writing the file"
EDITOR=nano visudo

mkdir /home/greg/Code
cp -r /root/Arch /home/greg/Code

