#!/usr/bin/env zsh

set -e -o verbose

# env

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-~/.config}
export XDG_DATA_HOME=${XDG_DATA_HOME:-~/.local/share}

# paru

export CARGO_HOME=$XDG_DATA_HOME/cargo

[[ -d ~/paru ]] && rm -rf ~/paru
pushd ~
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm
popd
rm -rf ~/paru

# packages

paru -S --aur --noconfirm \
  aic94xx-firmware \
  wd719x-firmware \
  upd72020x-fw

if [[ $MY_HOSTNAME = 'drifter' ]]; then

  sudo pacman -S --noconfirm \
    intel-ucode \
    alsa-firmware alsa-ucm-conf sof-firmware \
    iwd

  # sudo pacman -S --noconfirm \
  #   iio-sensor-proxy

  # intel gpu
  sudo pacman -S --noconfirm \
    intel-gpu-tools \
    intel-media-driver \
    vulkan-intel

fi

if [[ $MY_HOSTNAME = 'player' ]]; then

  sudo pacman -S --noconfirm \
    amd-ucode \
    argyllcms

  # nvidia gpu

  sudo pacman -S --noconfirm \
    nvidia nvidia-lts nvidia-settings nvidia-utils \
    libva-vdpau-driver

fi

if [[ $MY_HOSTNAME = 'worker' ]]; then

  sudo pacman -S --noconfirm \
    intel-ucode

  # amd gpu

  sudo pacman -S --noconfirm \
    mesa xf86-video-amdgpu \
    vulkan-radeon \
    libva-mesa-driver mesa-vdpau

  paru -S --aur --noconfirm \
    amdfand-bin

fi

# desktop

if [[ $MY_DESKTOP = 'GNOME' ]]; then

  sudo pacman -S --noconfirm \
    gnome-menus gnome-shell gnome-shell-extensions gnome-keyring gvfs gvfs-smb xdg-user-dirs-gtk \
    xdg-desktop-portal-gnome xdg-desktop-portal-gtk \
    eog evince gnome-calculator gnome-control-center gnome-system-monitor gnome-terminal gnome-tweak-tool nautilus \
    gnome-shell-extension-appindicator

    # gnome-software

  paru -S --aur --noconfirm \
    gnome-browser-connector \
    gnome-shell-extension-blur-my-shell

    # gnome-shell-extension-rounded-window-corners-git

fi

# colors

if [[ $MY_HOSTNAME = 'player' ]]; then

  dispwin -d1 -I `dirname $0`/home/$USER/.config/color/icc/devices/display/27gp950-b.icm

fi

# if [[ $MY_HOSTNAME = 'worker' ]]; then
#
#   dispwin -d1 -I `dirname $0`/home/$USER/.config/color/icc/devices/display/27ul850-w.icm
#   dispwin -d2 -I `dirname $0`/home/$USER/.config/color/icc/devices/display/27ud88-w.icm
#
# fi

# fonts

[[ -d $XDG_CONFIG_HOME/fontconfig ]] || mkdir -p $XDG_CONFIG_HOME/fontconfig
cp `dirname $0`/home/$USER/.config/fontconfig/fonts.conf $XDG_CONFIG_HOME/fontconfig
fc-cache -f

