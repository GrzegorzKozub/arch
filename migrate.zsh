#!/usr/bin/env zsh

set -o verbose

# argyllcms

sudo pacman -S --noconfirm argyllcms

# apsis

. `dirname $0`/apsis.zsh

# dconf

dconf reset -f /io/github/

# docker

echo 'options overlay metacopy=off redirect_dir=off' | \
  sudo tee /etc/modprobe.d/disable-overlay-redirect-dir.conf > \
  /dev/null

sudo systemctl stop docker.service
sudo systemctl disable docker.service

paru -S --aur --noconfirm docker-rootless-extras

for FILE in subuid subgid; do
  echo "$USER:231072:65536" | \
    sudo tee /etc/$FILE > /dev/null
done

DIR=/etc/systemd/system/user@.service.d
[[ -d $DIR ]] || sudo mkdir -p $DIR

echo '[Service]\nDelegate=cpu cpuset io memory pids' | \
  sudo tee $DIR/delegate.conf > /dev/null

systemctl --user enable docker.socket
systemctl --user start docker.socket

sudo gpasswd --delete $USER docker

# dust

rm -f ~/.config/dust
sudo pacman -Rs --noconfirm dust

# intel

sudo pacman -Rs --noconfirm libva-vdpau-driver

# mission-center

sudo pacman -S --noconfirm mission-center

# refine

# https://aur.archlinux.org/packages/refine
# https://gitlab.gnome.org/TheEvilSkeleton/Refine/-/issues/43

# paru -S --aur --noconfirm refine

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

