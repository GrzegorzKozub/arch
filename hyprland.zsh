#!/usr/bin/env zsh

set -e -o verbose

# nvidia

if [[ $HOST = 'player' ]]; then

  [[ $(sudo pacman -Qs nvidia) ]] && sudo pacman -Rs --noconfirm nvidia
  [[ $(sudo pacman -Qs nvidia-lts) ]] && sudo pacman -Rs --noconfirm nvidia-lts

  sudo pacman -S --noconfirm \
    linux-headers nvidia-dkms

  sudo sed -i -e 's/^MODULES=(.*)$/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
  sudo mkinitcpio -p linux

  echo 'options nvidia-drm modeset=1' | sudo tee /etc/modprobe.d/nvidia.conf > /dev/null

  echo 'options nvidia NVreg_PreserveVideoMemoryAllocations=1 NVreg_TemporaryFilePath=/var/tmp' |
    sudo tee /etc/modprobe.d/nvidia-power-management.conf > /dev/null
  sudo systemctl enable nvidia-hibernate.service
  sudo systemctl enable nvidia-suspend.service

  sudo sed -i -e 's/^.+WaylandEnable=.+$/#WaylandEnable=false/' /etc/gdm/custom.conf
  sudo ln -sf /dev/null /etc/udev/rules.d/61-gdm.rules

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
  waybar wofi \
  gammastep \
  brightnessctl \
  pavucontrol \
  grim slurp \
  swayimg

paru -S --aur --noconfirm \
  ttf-material-design-icons-extended

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

sudo pacman --noconfirm -Rsn $(pacman -Qdtq)

# dotfiles

. ~/code/dotfiles/hyprland.zsh

