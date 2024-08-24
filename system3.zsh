#!/usr/bin/env zsh

set -e -o verbose

# env

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-~/.config}
export XDG_DATA_HOME=${XDG_DATA_HOME:-~/.local/share}

# paru

CARGO_HOME=

[[ -d ~/paru ]] && rm -rf ~/paru

pushd ~

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm

popd

rm -rf ~/paru
rm -rf ~/.cargo

sudo pacman -Rs --noconfirm \
  rust

# firmware

paru -S --aur --noconfirm \
  aic94xx-firmware \
  wd719x-firmware \
  upd72020x-fw

if [[ $MY_HOSTNAME = 'drifter' ]]; then

  # ucode

  sudo pacman -S --noconfirm \
    intel-ucode

  # firmware

  sudo pacman -S --noconfirm \
    alsa-firmware alsa-ucm-conf \
    linux-firmware-qlogic \
    sof-firmware

  paru -S --aur --noconfirm \
    ast-firmware

  # intel gpu

  sudo pacman -S --noconfirm \
    intel-gpu-tools \
    intel-media-driver \
    vulkan-intel

fi

if [[ $MY_HOSTNAME = 'player' ]]; then

  # ucode

  sudo pacman -S --noconfirm \
    amd-ucode

  # firmware

  sudo pacman -S --noconfirm \
    linux-firmware-qlogic

  paru -S --aur --noconfirm \
    ast-firmware

  # nvidia gpu

  sudo pacman -S --noconfirm \
    nvidia nvidia-lts nvidia-settings nvidia-utils \
    libva-nvidia-driver

  # enable nvidia overclocking
  sudo cp `dirname $0`/etc/X11/xorg.conf.d/20-nvidia.conf /etc/X11/xorg.conf.d/20-nvidia.conf

  # disable rootless xorg to allow nvidia overclocking
  # sudo cp `dirname $0`/etc/X11/Xwrapper.config /etc/X11/Xwrapper.config

fi

if [[ $MY_HOSTNAME = 'worker' ]]; then

  # ucode

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
    gnome-menus gnome-shell gnome-shell-extensions gnome-keyring \
    gvfs gvfs-smb \
    xdg-user-dirs-gtk \
    xdg-desktop-portal-gnome xdg-desktop-portal-gtk \
    evince gnome-calculator gnome-characters gnome-control-center gnome-font-viewer gnome-screenshot gnome-system-monitor gnome-terminal gnome-tweak-tool loupe nautilus \
    gnome-shell-extension-appindicator

    # gnome-software

  paru -S --aur --noconfirm \
    gnome-browser-connector \
    gnome-shell-extension-blur-my-shell \
    gnome-shell-extension-rounded-window-corners-reborn

fi

