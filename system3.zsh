#!/usr/bin/env zsh

set -e -o verbose

# paru

[[ -d ~/paru ]] && rm -rf ~/paru
pushd ~
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm
popd
rm -rf ~/paru

# operating system continued

paru -S --aur --noconfirm \
  aic94xx-firmware wd719x-firmware upd72020x-fw \
  gnome-shell-extension-tray-icons

if [[ $MY_HOSTNAME = 'drifter' ]]; then

  sudo pacman -S --noconfirm \
    dialog dhcpcd netctl wpa_supplicant \
    intel-media-driver \
    bluez bluez-utils

  paru -S --aur --noconfirm \
    laptop-mode-tools \
    gnome-shell-extension-dim-on-battery-git

fi

if [[ $MY_HOSTNAME = 'turing' ]]; then

  sudo pacman -S --noconfirm \
    nvidia

fi

