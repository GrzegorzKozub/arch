#!/usr/bin/env zsh

set -e -o verbose

# nvidia

if [[ $HOST = 'player' ]]; then

  # wayland

  FILE=/boot/loader/entries/01-arch.conf
  OPT=nvidia-drm.modeset=1
  [[ $(sudo grep $OPT $FILE) ]] || sudo sed -i "/^options/ s/$/ $OPT/" $FILE

  # hyprland

  [[ $(sudo pacman -Qs nvidia) ]] && sudo pacman -Rs --noconfirm nvidia
  [[ $(sudo pacman -Qs nvidia-lts) ]] && sudo pacman -Rs --noconfirm nvidia-lts

  sudo pacman -S --noconfirm \
    linux-headers nvidia-dkms

  sudo sed -i -e 's/^MODULES=(.*)$/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
  sudo mkinitcpio -p linux

  echo 'options nvidia-drm modeset=1' | sudo tee /etc/modprobe.d/nvidia.conf > /dev/null

fi

# packages

if [[ $HOST = 'player' ]]; then

  sudo pacman -S --noconfirm \
    foot

  paru -S --aur --noconfirm \
    hyprland-nvidia

else

  paru -S --aur --noconfirm \
    hyprland-git

fi

sudo pacman -S --noconfirm \
  xdg-desktop-portal-hyprland \
  hyprpaper \
  swayidle swaylock \
  waybar wofi dunst \
  gammastep brightnessctl \
  pavucontrol \
  grim slurp \
  swayimg

if [[ $HOST = 'drifter' ]]; then

  sudo pacman -S --noconfirm \
    iwd

  sudo systemctl enable iwd.service

fi

paru -S --aur --noconfirm \
  hyprpicker

# links

for APP in \
  gammastep \
  gammastep-indicator \
  pavucontrol
do
  cp /usr/share/applications/$APP.desktop $XDG_DATA_HOME/applications
  sed -i '2iNoDisplay=true' $XDG_DATA_HOME/applications/$APP.desktop
done

if [[ $HOST = 'player' ]]; then

  for APP in \
    org.codeberg.dnkl.foot-server \
    org.codeberg.dnkl.foot \
    org.codeberg.dnkl.footclient
  do
    cp /usr/share/applications/$APP.desktop $XDG_DATA_HOME/applications
    sed -i '2iStartupWMClass=foot' $XDG_DATA_HOME/applications/$APP.desktop
  done

  for APP in \
    org.codeberg.dnkl.foot-server \
    org.codeberg.dnkl.footclient
  do
    sed -i '2iNoDisplay=true' $XDG_DATA_HOME/applications/$APP.desktop
  done

  sed -i \
    -e "s/^Exec=foot$/Exec=foot --override=include=~\/.config\/foot\/$HOST.ini/" \
    $XDG_DATA_HOME/applications/org.codeberg.dnkl.foot.desktop
fi

# disable gnome xdg-desktop-portal

systemctl --user mask xdg-desktop-portal-gnome xdg-desktop-portal-gtk

# cleanup

sudo pacman -Rs --noconfirm \
  cmake

. `dirname $0`/packages.zsh

# dotfiles

. ~/code/dotfiles/hyprland.zsh

