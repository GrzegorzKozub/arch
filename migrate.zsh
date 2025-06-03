#!/usr/bin/env zsh

set -o verbose

# gnome-disk-utility

sudo pacman -R --noconfirm gnome-disk-utility

# noatime

sudo sed -i \
  -e "s/ext4      	rw,relatime/ext4      	rw,noatime/" \
  -e "s/ext4    defaults /ext4    defaults,noatime /" \
  /etc/fstab

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

