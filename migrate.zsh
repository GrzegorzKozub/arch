#!/usr/bin/env zsh

set -o verbose

# cleanup

rm -rf $XDG_CONFIG_HOME/.org.chromium.Chromium.W6m8Be
rm -rf $XDG_CONFIG_HOME/monitors.xml~

[[ $HOST = 'drifter' ]] && sudo rm -rf /etc/udev/rules.d/10-hd-3000.rules

# firmware

[[ $HOST = 'worker' ]] && sudo pacman -S --noconfirm sof-firmware

# hosts

sudo sed -i -e "/.*integrations-stage.apsis.cloud.*/d" /etc/hosts
sudo sed -i -e "/.*hls.aud-stage.apsis.cloud.*/d" /etc/hosts

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

