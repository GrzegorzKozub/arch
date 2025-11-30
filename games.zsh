#!/usr/bin/env zsh

set -e -o verbose

# https://github.com/GloriousEggroll/proton-ge-custom
#   Consider adding yourself to the games group to make this work by issuing: usermod -a -G games
# https://github.com/doitsujin/dxvk
# https://github.com/HansKristian-Work/vkd3d-proton
# env LD_PRELOAD="$LD_PRELOAD:/usr/lib/libgamemode.so.0" PROTON_ENABLE_NGX_UPDATER=1 PROTON_ENABLE_NVAPI=1 VKD3D_CONFIG=dxr11,dxr WINE_FULLSCREEN_FSR=1 WINE_FULLSCREEN_FSR_MODE=ultra WINE_FULLSCREEN_FSR_STRENGTH=2 mangohud gamemoderun %command%`
#
# https://wiki.archlinux.org/title/Gamescope
#
# https://forum.foldingathome.org/viewtopic.php?p=372040
# https://wiki.archlinux.org/title/NVIDIA/Tips_and_tricks#Lowering_GPU_boost_clocks

# partition lookup

[[ $HOST == 'player' ]] && UUID='59881a75-9eac-482a-bcbf-94ce252d9f6b'
[[ $HOST == 'worker' ]] && UUID='...'

DISK="$(lsblk -lno PATH,UUID | grep -i $UUID | cut -d' ' -f1)"
[[ -z $DISK ]] && exit 1

# auto-mount

MOUNT=/run/media/$USER/games

[[ -d $MOUNT ]] || {
  sudo mkdir -p $MOUNT
  sudo chown $USER $MOUNT
  sudo chgrp users $MOUNT
}

[[ $(mount | grep "$DISK on $MOUNT") ]] || sudo mount $DISK $MOUNT

[[ $(grep "# $DISK" /etc/fstab) ]] || {
  echo "# $DISK" | sudo tee --append /etc/fstab > /dev/null
  echo "UUID=$UUID	$MOUNT	ext4	defaults,noatime	0 2" | sudo tee --append /etc/fstab > /dev/null
  echo '' | sudo tee --append /etc/fstab > /dev/null
}

sudo `dirname $0`/fstab.sh

# multilib

LINE=$(grep -n '#\[multilib\]' /etc/pacman.conf | awk '{print $1}' FS=':')

[[ $LINE ]] && {
  sudo sed -i "${LINE}s/#//" /etc/pacman.conf
  sudo sed -i "${$(($LINE + 1))}s/#//" /etc/pacman.conf
}

sudo pacman -Sy

# performance optimization

sudo cp `dirname $0`/etc/sysctl.d/80-gaming.conf /etc/sysctl.d
sudo cp `dirname $0`/etc/tmpfiles.d/gaming.conf /etc/tmpfiles.d

cp `dirname $0`/home/$USER/.config/systemd/user/pci.service $XDG_CONFIG_HOME/systemd/user
systemctl --user enable pci.service

# nvidia

cp `dirname $0`/home/$USER/.config/systemd/user/nvidia.{service,timer} $XDG_CONFIG_HOME/systemd/user
systemctl --user enable nvidia.timer

sudo systemctl enable nvidia-persistenced.service

# vulkan

# sudo pacman -S --noconfirm \
#   lib32-vulkan-validation-layers

# pipewire

# sudo pacman -S --noconfirm \
#   lib32-pipewire

# steam

sudo pacman -S --noconfirm \
  lib32-nvidia-utils \
  steam

rm -rf ~/Desktop/steam.desktop

[[ $XDG_CURRENT_DESKTOP = 'GNOME' ]] && {
  FAVS=$(gsettings get org.gnome.shell favorite-apps)
  [[ $(echo $FAVS | grep 'steam.desktop') ]] || {
    FAVS=$(echo $FAVS | sed "s/\]/, 'steam.desktop']/")
    gsettings set org.gnome.shell favorite-apps $FAVS
  }
}

[[ -d $MOUNT/Steam ]] && {
  rm -f $XDG_DATA_HOME/Steam
  ln -s $MOUNT/Steam $XDG_DATA_HOME/Steam
}

# proton-ge-custom

# sudo pacman -S --noconfirm \
#   lib32-at-spi2-core

paru -S --aur --noconfirm \
  proton-ge-custom-bin

# gamemode

sudo pacman -S --noconfirm \
  gamemode
  # lib32-gamemode

sudo usermod -a -G gamemode $(whoami)

# mangohud

sudo pacman -S --noconfirm \
  mangohud
  # lib32-mangohud

[[ -d $XDG_DATA_HOME/mangohud ]] || mkdir -p $XDG_DATA_HOME/mangohud
cp /usr/share/fonts/OTF/CascadiaCode-Regular.otf $XDG_DATA_HOME/mangohud

# cleanup

. `dirname $0`/packages.zsh

# dotfiles

. ~/code/dot/games.zsh

