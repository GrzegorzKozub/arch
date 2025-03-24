#!/usr/bin/env zsh

set -o verbose

# bluez

sudo chmod 555 /etc/bluetooth

# tmux

# for DIR in \
#   plugins/tmux-fzf-links
# do
#   rm -rf $XDG_DATA_HOME/tmux/$DIR
# done

# $XDG_DATA_HOME/tmux/plugins/tpm/bindings/install_plugins

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

