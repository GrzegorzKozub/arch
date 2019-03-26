set -o verbose

# time sync

timedatectl set-ntp true

# internet

wifi-menu
sleep 10
#elinks google.com

# pacman mirror list

cp `dirname $0`/etc/pacman.d/mirrorlist /etc/pacman.d
pacman -Sy --noconfirm reflector
reflector --country Poland --sort rate --save /etc/pacman.d/mirrorlist

# backup tool

pacman -Sy --noconfirm fsarchiver

