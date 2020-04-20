#!/usr/bin/env zsh

set -e -o verbose

# time sync

timedatectl set-ntp true

# internet

ping -c 1 8.8.8.8 || ( wifi-menu && sleep 10 )

# pacman mirror list

echo 'Server = http://arch.midov.pl/arch/$repo/os/$arch' > /etc/pacman.d/mirrorlist

# tools

pacman -Sy --noconfirm git

# scripts

[[ -d ~/arch ]] && rm -rf ~/arch
git clone https://github.com/GrzegorzKozub/arch.git ~/arch

