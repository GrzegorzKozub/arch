#!/usr/bin/env zsh

set -o verbose

# fstab

sudo sed -i \
  -e "s/ext4[[:space:]]\+rw,relatime/ext4 rw,noatime/" \
  -e "s/fmask=0022/fmask=0077/" \
  -e "s/dmask=0022/dmask=0077/" \
  /etc/fstab

sudo `dirname $0`/fstab.sh

# gnome

DIR='/org/gnome/desktop/wm/keybindings'

dconf reset $DIR/begin-move
dconf reset $DIR/begin-resize
dconf reset $DIR/toggle-fullscreen

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

