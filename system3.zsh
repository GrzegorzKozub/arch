#!/usr/bin/env zsh

set -e -o verbose

# paru

export CARGO_HOME=${XDG_DATA_HOME:-~/.local/share}/cargo

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
  gnome-shell-extension-tray-icons-reloaded-git

if [[ $MY_HOSTNAME = 'player' ]]; then

  sudo pacman -S --noconfirm \
    amd-ucode \
    nvidia nvidia-lts

fi

if [[ $MY_HOSTNAME = 'drifter' ]]; then

  sudo pacman -S --noconfirm \
    iwd \
    intel-ucode \
    intel-media-driver \
    alsa-firmware alsa-ucm-conf sof-firmware

  paru -S --aur --noconfirm \
    gnome-shell-extension-dim-on-battery-git

fi

if [[ $MY_HOSTNAME = 'worker' ]]; then

  sudo pacman -S --noconfirm \
    intel-ucode \
    nvidia nvidia-lts

fi

