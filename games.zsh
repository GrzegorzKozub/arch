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
  echo "$DISK	$MOUNT	ext4	defaults	0 2" | sudo tee --append /etc/fstab > /dev/null
  echo '' | sudo tee --append /etc/fstab > /dev/null
}

# multilib

LINE=$(grep -n '#\[multilib\]' /etc/pacman.conf | awk '{print $1}' FS=':')

[[ $LINE ]] && {
  sudo sed -i "${LINE}s/#//" /etc/pacman.conf
  sudo sed -i "${$(($LINE + 1))}s/#//" /etc/pacman.conf
}

sudo pacman -Sy

# pipewire

sudo pacman -S --noconfirm \
  lib32-pipewire

# nvidia

sudo pacman -S --noconfirm \
  nvidia-settings

DIR=${XDG_DATA_HOME:-~/.local/share}/nvidia-settings
[[ -d $DIR ]] || mkdir $DIR

LOCAL=${XDG_DATA_HOME:-~/.local/share}/applications
APP=nvidia-settings.desktop

cp /usr/share/applications/$APP $LOCAL
sed -i \
  -e 's/^Name=.*$/Name=NVIDIA/' \
  -e 's/^Exec=.*$/Exec=\/usr\/bin\/nvidia-settings --config=\/home\/greg\/.local\/share\/nvidia-settings\/nvidia-settings-rc/' \
  $LOCAL/$APP

sudo cp `dirname $0`/etc/X11/xorg.conf.d/20-nvidia.conf /etc/X11/xorg.conf.d/20-nvidia.conf

cp `dirname $0`/home/greg/.config/systemd/user/nvidia.service ~/.config/systemd/user
systemctl --user enable nvidia.service

# steam

sudo pacman -S --noconfirm \
  lib32-nvidia-utils \
  steam

[[ $XDG_CURRENT_DESKTOP = 'GNOME' ]] && {
  FAVS=$(gsettings get org.gnome.shell favorite-apps)
  [[ $(echo $FAVS | grep 'steam.desktop') ]] || {
    FAVS=$(echo $FAVS | sed "s/\]/, 'steam.desktop']/")
    gsettings set org.gnome.shell favorite-apps $FAVS
  }
}

[[ $XDG_CURRENT_DESKTOP = 'KDE' ]] && {
  sed -i '/^launchers=/ s/$/,applications:steam.desktop/' ${XDG_CONFIG_HOME:-~/.config}/plasma-org.kde.plasma.desktop-appletsrc
  kquitapp5 plasmashell && kstart5 plasmashell &
}

[[ -d $MOUNT/Steam ]] && {
  DIR=${XDG_DATA_HOME:-~/.local/share}/Steam
  rm -f $DIR
  ln -s $MOUNT/Steam $DIR
}

LOCAL=${XDG_DATA_HOME:-~/.local/share}/applications
APP=steam.desktop

cp /usr/share/applications/$APP $LOCAL
sed -i -e 's/^Name=.*$/Name=Steam/' $LOCAL/$APP

# proton-ge-custom

sudo pacman -S --noconfirm \
  lib32-at-spi2-core

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

sudo pacman -S --noconfirm \
  python-distutils-extra

paru -S --aur --noconfirm \
  lib32-mangohud \
  mangohud \
  mangohud-common

DIR=${XDG_DATA_HOME:-~/.local/share}/mangohud
[[ -d $DIR ]] || mkdir -p $DIR
cp /usr/share/fonts/OTF/CascadiaCode-Regular.otf $DIR

# libstrangle

paru -S --aur --noconfirm \
  libstrangle-git

# dotfiles

. ~/code/dotfiles/games.zsh

