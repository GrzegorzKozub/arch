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
  gnome-shell-extension-hide-activities-git \
  gnome-shell-extension-tray-icons-reloaded-git

if [[ $MY_HOSTNAME = 'player' ]]; then

  sudo pacman -S --noconfirm \
    amd-ucode \
    nvidia nvidia-lts nvtop \
    argyllcms

fi

if [[ $MY_HOSTNAME = 'drifter' ]]; then

  sudo pacman -S --noconfirm \
    intel-ucode \
    intel-gpu-tools intel-media-driver \
    alsa-firmware alsa-ucm-conf sof-firmware \
    iwd

  # sudo pacman -S --noconfirm \
    # iio-sensor-proxy

fi

if [[ $MY_HOSTNAME = 'worker' ]]; then

  sudo pacman -S --noconfirm \
    intel-ucode \
    nvidia nvidia-lts nvtop \
    argyllcms

fi

# colors

if [[ $MY_HOSTNAME = 'player' ]]; then

  dispwin -d1 -I `dirname $0`/home/greg/.config/color/icc/devices/display/27gp950-b.icm

fi

if [[ $MY_HOSTNAME = 'worker' ]]; then

  dispwin -d1 -I `dirname $0`/home/greg/.config/color/icc/devices/display/27ul850-w.icm
  dispwin -d2 -I `dirname $0`/home/greg/.config/color/icc/devices/display/27ud88-w.icm

fi

# fonts

[[ -d ~/.config/fontconfig ]] || mkdir -p ~/.config/fontconfig
cp `dirname $0`/home/greg/.config/fontconfig/fonts.conf ~/.config/fontconfig
fc-cache -f

