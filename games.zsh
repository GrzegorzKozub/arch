#!/usr/bin/env zsh

set -e -o verbose

# validation

[[ $HOST = 'player' ]] || exit 1

# mount

DISK=/dev/nvme1n1p2
MOUNT=/run/media/$USER/games

[[ -d $MOUNT ]] || {
  sudo mkdir -p $MOUNT
  sudo chown $USER $MOUNT
  sudo chgrp users $MOUNT
}

[[ $(mount | grep "$DISK on $MOUNT") ]] || sudo mount $DISK $MOUNT

[[ $(grep "# $DISK" /etc/fstab) ]] || {
  echo "# $DISK" | sudo tee --append /etc/fstab > /dev/null
  echo "$DISK	$MOUNT	ext4	defaults	0 1" | sudo tee --append /etc/fstab > /dev/null
  echo '' | sudo tee --append /etc/fstab > /dev/null
}

# multilib

LINE=$(grep -n '#\[multilib\]' /etc/pacman.conf | awk '{print $1}' FS=':')

[[ $LINE ]] && {
  sudo sed -i "${LINE}s/#//" /etc/pacman.conf
  sudo sed -i "${$(($LINE + 1))}s/#//" /etc/pacman.conf
}

sudo pacman -Sy

# nvidia-settings

sudo pacman -S --noconfirm \
  nvidia-settings

sudo cp `dirname $0`/etc/X11/xorg.conf.d/20-nvidia.conf /etc/X11/xorg.conf.d/20-nvidia.conf

[[ -d $XDG_DATA_HOME/nvidia-settings ]] || mkdir $XDG_DATA_HOME/nvidia-settings

for APP in \
  nvidia-settings
do
  cp /usr/share/applications/$APP.desktop ~/.local/share/applications
  sed -i \
    -e 's/^Name=.*$/Name=NVIDIA/' \
    -e 's/^Exec=.*$/Exec=\/usr\/bin\/nvidia-settings --config=\/home\/greg\/.local\/share\/nvidia-settings\/nvidia-settings-rc/' \
    ~/.local/share/applications/$APP.desktop
done

# steam

sudo pacman -S --noconfirm \
  lib32-nvidia-utils \
  steam

FAVS=$(gsettings get org.gnome.shell favorite-apps)

[[ $(echo $FAVS | grep 'steam.desktop') ]] || {
  FAVS=$(echo $FAVS | sed "s/\]/, 'steam.desktop']/")
  gsettings set org.gnome.shell favorite-apps $FAVS
}

[[ -d $MOUNT/Steam ]] && {
  rm -f ${XDG_DATA_HOME:-~/.local/share}/Steam
  ln -s $MOUNT/Steam ${XDG_DATA_HOME:-~/.local/share}/Steam
}

for APP in \
  steam
do
  cp /usr/share/applications/$APP.desktop ~/.local/share/applications
  sed -i \
    -e 's/^Name=.*$/Name=Steam/' \
    ~/.local/share/applications/$APP.desktop
done

# proton-ge-custom

paru -S --aur --noconfirm \
  proton-ge-custom-bin

# gamemode

[[ $(grep gamemode /etc/group) ]] || sudo groupadd gamemode
sudo usermod -a -G gamemode $(whoami)

sudo pacman -S --noconfirm \
  gamemode \
  lib32-gamemode

systemctl --user enable gamemoded.service
systemctl --user start gamemoded.service

# mangohud

paru -S --aur --noconfirm \
  lib32-mangohud \
  mangohud

# libstrangle

paru -S --aur --noconfirm \
  libstrangle-git

# dotfiles

. ~/code/dotfiles/games.zsh

