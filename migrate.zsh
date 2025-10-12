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

# work

if [[ $HOST = 'drifter' ]]; then

  cp `dirname $0`/home/$USER/.config/systemd/user/iam.service $XDG_CONFIG_HOME/systemd/user
  systemctl --user enable iam.service

  . `dirname $0`/work.zsh

fi

# reset

# . `dirname $0`/reset.zsh

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

