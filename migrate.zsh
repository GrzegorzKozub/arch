#!/usr/bin/env zsh

# set -o verbose
#
# sudo pacman -S --noconfirm \
#   go-yq \
#   silicon \
#   zoxide
#
# paru -S --aur --noconfirm \
#   ttf-victor-mono

cp `dirname $0`/home/$USER/.config/systemd/user/fetch.service $XDG_CONFIG_HOME/systemd/user
systemctl --user enable fetch.service

