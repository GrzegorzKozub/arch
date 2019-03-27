set -o verbose

# time sync

timedatectl set-ntp true

# internet

wifi-menu
sleep 10
#elinks google.com

# pacman mirror list

pacman -Sy --noconfirm reflector
reflector --country Poland --sort rate --save /etc/pacman.d/mirrorlist

# backup tool

pacman -Sy --noconfirm fsarchiver

