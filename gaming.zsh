#!/usr/bin/env zsh

set -e -o verbose

# multilib

LINE=$(grep -n '#\[multilib\]' /etc/pacman.conf | awk '{print $1}' FS=':')

[[ $LINE ]] && {
  sudo sed -i "${LINE}s/#//" /etc/pacman.conf
  sudo sed -i "${$(($LINE + 1))}s/#//" /etc/pacman.conf
}

sudo pacman -Sy

# steam

sudo pacman -S --noconfirm steam

MOUNT=/run/media/$USER/steam

[[ -d $MOUNT ]] || {
  sudo mkdir -p $MOUNT
  sudo chown $USER $MOUNT
  sudo chgrp users $MOUNT
}

[[ $(mount | grep "sda2 on $MOUNT") ]] || sudo mount /dev/sda2 $MOUNT

[[ ! -d $MOUNT/Steam ]] && {
  steam
  mv ${XDG_DATA_HOME:-~/.local/share}/Steam $MOUNT/Steam
}

ln -s $MOUNT/Steam ${XDG_DATA_HOME:-~/.local/share}/Steam

# gamemode

sudo pacman -S --noconfirm gamemode lib32-gamemode
systemctl --user enable gamemoded.service
systemctl --user start gamemoded.service

# mangohud

paru -S --aur --noconfirm mangohud lib32-mangohud

# links

for APP in \
  steam
do
  cp /usr/share/applications/$APP.desktop ~/.local/share/applications
  sed -i \
    -e 's/^Name=.*$/Name=Steam/' \
    ~/.local/share/applications/$APP.desktop
done

