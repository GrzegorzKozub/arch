#!/usr/bin/env bash
set -eo pipefail -ux

# partition lookup

[[ $HOST == 'player' ]] && UUID='59881a75-9eac-482a-bcbf-94ce252d9f6b'
[[ $HOST == 'worker' ]] && UUID='1fbc6b00-f28c-476a-9319-6640fb52d976'

DISK="$(lsblk -lno PATH,UUID | grep -i "$UUID" | cut -d' ' -f1)"
[[ -z $DISK ]] && exit 1

# auto-mount

MOUNT=/run/media/$USER/games

[[ -d $MOUNT ]] || {
  sudo mkdir -p "$MOUNT"
  sudo chown "$USER" "$MOUNT"
  sudo chgrp users "$MOUNT"
}

mount | grep "$DISK on $MOUNT" || sudo mount "$DISK" "$MOUNT"

grep "# $DISK" /etc/fstab || {
  echo "# $DISK" | sudo tee --append /etc/fstab > /dev/null
  echo "UUID=$UUID	$MOUNT	ext4	defaults,noatime	0 2" | sudo tee --append /etc/fstab > /dev/null
  echo '' | sudo tee --append /etc/fstab > /dev/null
}

sudo "${BASH_SOURCE%/*}"/fstab.sh

# multilib

LINE=$(grep -n '#\[multilib\]' /etc/pacman.conf | awk '{print $1}' FS=':')

[[ $LINE ]] && {
  sudo sed -i "${LINE}s/#//" /etc/pacman.conf
  sudo sed -i "$((LINE + 1))s/#//" /etc/pacman.conf
}

sudo pacman -Sy

# steam

sudo pacman -S --noconfirm \
  lib32-nvidia-utils \
  steam

rm -rf ~/Desktop/steam.desktop

[[ $XDG_CURRENT_DESKTOP == 'GNOME' ]] && {
  FAVS=$(gsettings get org.gnome.shell favorite-apps)
  echo "$FAVS" | grep -q 'steam.desktop' || {
    FAVS=${FAVS/]/, \'steam.desktop\']}
    gsettings set org.gnome.shell favorite-apps "$FAVS"
  }
}

[[ -d $MOUNT/Steam ]] && {
  rm -f "$XDG_DATA_HOME"/Steam
  ln -s "$MOUNT"/Steam "$XDG_DATA_HOME"/Steam
}

# gamemode

sudo pacman -S --noconfirm \
  gamemode

sudo usermod -aG gamemode "$USER"

# mangohud

sudo pacman -S --noconfirm \
  mangohud

[[ -d $XDG_DATA_HOME/mangohud ]] || mkdir -p "$XDG_DATA_HOME"/mangohud
cp /usr/share/fonts/OTF/CascadiaCode-Regular.otf "$XDG_DATA_HOME"/mangohud

# proton

paru -S --aur --noconfirm \
  proton-cachyos-slr \
  proton-ge-custom-bin

sudo cp "${BASH_SOURCE%/*}"/etc/modules-load.d/ntsync.conf /etc/modules-load.d

# gamescope

# paru -S --aur --noconfirm \
#   gamescope-git
#
# sudo pacman -Rs --noconfirm \
#   cmake

# cleanup

"${BASH_SOURCE%/*}"/packages.sh

# dotfiles

~/code/dot/games.sh
