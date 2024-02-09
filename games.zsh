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

sudo cp `dirname $0`/etc/X11/xorg.conf.d/20-nvidia.conf /etc/X11/xorg.conf.d/20-nvidia.conf

cp `dirname $0`/home/$USER/.config/systemd/user/nvidia.service $XDG_CONFIG_HOME/systemd/user
systemctl --user enable nvidia.service

sudo systemctl enable nvidia-persistenced.service

# vulkan

sudo pacman -S --noconfirm \
  lib32-vulkan-validation-layers

# steam

# https://github.com/ValveSoftware/steam-for-linux/issues/9805
# sudo pacman -S --noconfirm \
#   lib32-libnm

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
  sed -i '/^launchers=/ s/$/,applications:steam.desktop/' $XDG_CONFIG_HOME/plasma-org.kde.plasma.desktop-appletsrc
  kquitapp5 plasmashell && kstart5 plasmashell &
}

[[ -d $MOUNT/Steam ]] && {
  rm -f $XDG_DATA_HOME/Steam
  ln -s $MOUNT/Steam $XDG_DATA_HOME/Steam
}

cp /usr/share/applications/steam.desktop $XDG_DATA_HOME/applications
sed -i \
  -e 's/^Name=.*$/Name=Steam/' \
  -e 's/steam-runtime/env STEAM_FORCE_DESKTOPUI_SCALING=1.5 steam-runtime/' \
  $XDG_DATA_HOME/applications/steam.desktop

  # -e 's/steam-runtime/steam-runtime -forcedesktopscaling 1.5/' \

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
  lib32-mangohud \
  mangohud

[[ -d $XDG_DATA_HOME/mangohud ]] || mkdir -p $XDG_DATA_HOME/mangohud
cp /usr/share/fonts/OTF/CascadiaCode-Regular.otf $XDG_DATA_HOME/mangohud

# libstrangle

# paru -S --aur --noconfirm \
#   libstrangle-git

# cleanup

. `dirname $0`/packages.zsh

# dotfiles

. ~/code/dotfiles/games.zsh

