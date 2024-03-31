#!/usr/bin/env zsh

set -o verbose

# fetch

cp `dirname $0`/home/$USER/.config/systemd/user/fetch.service $XDG_CONFIG_HOME/systemd/user
systemctl --user enable fetch.service

