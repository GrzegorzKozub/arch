#!/usr/bin/env zsh

set -e -o verbose

# packages

paru -S --aur --noconfirm \
  teams-for-linux

# links

cp /usr/share/applications/teams-for-linux.desktop $XDG_DATA_HOME/applications
sed -i -e 's/^Name=.*/Name=Teams/' $XDG_DATA_HOME/applications/teams-for-linux.desktop

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

# dotfiles

. ~/code/dotfiles/teams.zsh

