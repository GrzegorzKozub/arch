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

[[ -d ~/.local/share/gnupg ]] || mkdir -p ~/.local/share/gnupg
chmod 700 ~/.local/share/gnupg

# operating system continued

yay -S --aur --noconfirm \
  aic94xx-firmware wd719x-firmware upd72020x-fw \
  gnome-shell-extension-tray-icons

if [[ $MY_HOSTNAME = 'drifter' ]]; then

  sudo pacman -S --noconfirm \
    dialog dhcpcd netctl wpa_supplicant \
    intel-media-driver \
    bluez bluez-utils

  yay -S --aur --noconfirm \
    laptop-mode-tools \
    gnome-shell-extension-dim-on-battery-git

fi

if [[ $MY_HOSTNAME = 'turing' ]]; then

  sudo pacman -S --noconfirm \
    nvidia

fi

