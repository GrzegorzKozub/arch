#!/usr/bin/env zsh

set -o verbose

# fstab

sudo sed -i '/^# \/dev\/mapper\/vg1-data/d' /etc/fstab
sudo `dirname $0`/fstab.sh

# gnome-disk-utility

sudo pacman -R --noconfirm gnome-disk-utility

# noatime

sudo sed -i \
  -e "s/ext4      	rw,relatime/ext4      	rw,noatime/" \
  -e "s/ext4    defaults /ext4    defaults,noatime /" \
  /etc/fstab

# node

npm uninstall --global tsx

# rclone & restic

sudo pacman -S --noconfirm rclone restic

pushd ~/code/dot
git pull
git update-index --assume-unchanged rclone/rclone/rclone.conf
popd

# nvim

# rm -rf $XDG_CACHE_HOME/nvim
# rm -rf $XDG_DATA_HOME/nvim
# rm -rf ~/.local/state/nvim
# nvim \
#   -c 'autocmd User MasonToolsUpdateCompleted quitall' \
#   -c 'autocmd User VeryLazy MasonToolsUpdate'

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

