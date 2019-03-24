set -o verbose

timedatectl set-ntp true

wifi-menu
sleep 10
#elinks google.com

cp `dirname $0`/etc/pacman.d/mirrorlist /etc/pacman.d
pacman -Sy --noconfirm reflector
reflector --country Poland --sort rate --save /etc/pacman.d/mirrorlist

pacman -Sy --noconfirm fsarchiver

