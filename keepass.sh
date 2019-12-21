set -e -o verbose

# keepassxc

sudo pacman -S --noconfirm keepassxc

cp -r `dirname $0`/home/greg/.config/keepassxc ~/.config

cp -r /mnt/.Arch/greg.kdbx ~/.config/keepassxc
cp -r /mnt/.Arch/keys/keepass/greg.key ~/.config/keepassxc

