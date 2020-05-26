#!/usr/bin/env zsh

set -e -o verbose

# yay

[[ -d ~/yay ]] && rm -rf ~/yay
pushd ~
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
popd
rm -rf ~/yay

# operating system continued

yay -S --aur --noconfirm \
  aic94xx-firmware wd719x-firmware \
  gnome-shell-extension-tray-icons

if [[ $MY_HOSTNAME = 'drifter' ]]; then

  sudo pacman -S --noconfirm \
    dialog dhcpcd netctl wpa_supplicant \
    intel-media-driver

  yay -S --aur --noconfirm \
    laptop-mode-tools \
    gnome-shell-extension-dim-on-battery-git

fi

if [[ $MY_HOSTNAME = 'turing' ]]; then

  sudo pacman -S --noconfirm \
    nvidia

fi

