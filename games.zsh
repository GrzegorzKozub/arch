#!/usr/bin/env zsh

set -e -o verbose

# todo: gamescope per https://wiki.archlinux.org/title/Gamescope
# todo: undervolt 5090 per https://forum.foldingathome.org/viewtopic.php?p=372040 and https://wiki.archlinux.org/title/NVIDIA/Tips_and_tricks#Lowering_GPU_boost_clocks

# partition lookup

[[ $HOST == 'player' ]] && UUID='59881a75-9eac-482a-bcbf-94ce252d9f6b'
[[ $HOST == 'worker' ]] && UUID='1fbc6b00-f28c-476a-9319-6640fb52d976'

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

# performance optimization

sudo cp `dirname $0`/etc/sysctl.d/80-gaming.conf /etc/sysctl.d
sudo cp `dirname $0`/etc/tmpfiles.d/gaming.conf /etc/tmpfiles.d

cp `dirname $0`/home/$USER/.config/systemd/user/pci.service $XDG_CONFIG_HOME/systemd/user
systemctl --user enable pci.service

# nvidia

cp `dirname $0`/home/$USER/.config/systemd/user/nvidia.{service,timer} $XDG_CONFIG_HOME/systemd/user
systemctl --user enable nvidia.timer

sudo systemctl enable nvidia-persistenced.service

# multilib

LINE=$(grep -n '#\[multilib\]' /etc/pacman.conf | awk '{print $1}' FS=':')

[[ $LINE ]] && {
  sudo sed -i "${LINE}s/#//" /etc/pacman.conf
  sudo sed -i "${$(($LINE + 1))}s/#//" /etc/pacman.conf
}

sudo pacman -Sy

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

# gamemode

sudo pacman -S --noconfirm \
  gamemode

sudo usermod -a -G gamemode $(whoami)

# mangohud

sudo pacman -S --noconfirm \
  mangohud

[[ -d $XDG_DATA_HOME/mangohud ]] || mkdir -p $XDG_DATA_HOME/mangohud
cp /usr/share/fonts/OTF/CascadiaCode-Regular.otf $XDG_DATA_HOME/mangohud

# proton-ge-custom

paru -S --aur --noconfirm \
  proton-ge-custom-bin

sudo cp `dirname $0`/etc/modules-load.d/ntsync.conf /etc/modules-load.d

# cleanup

. `dirname $0`/packages.zsh

# dotfiles

. ~/code/dot/games.zsh

