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

  yay -S --aur --noconfirm \
    laptop-mode-tools \
    gnome-shell-extension-dim-on-battery-git

fi

