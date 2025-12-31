#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  jdk-openjdk \
  dbeaver

# config

CFG=/usr/share/dbeaver/dbeaver.ini
OPT=-Dosgi.configuration.area
[[ $(grep $OPT $CFG) ]] || {
  echo "$OPT=@user.home/.local/share/DBeaver" | sudo tee --append $CFG > /dev/null
}

# links

cp /usr/share/applications/io.dbeaver.DBeaver.desktop $XDG_DATA_HOME/applications
sed -i -e 's/^Name=.*/Name=DBeaver/' $XDG_DATA_HOME/applications/io.dbeaver.DBeaver.desktop

# cleanup

. `dirname $0`/packages.zsh

# dotfiles

. ~/code/dot/dbeaver.zsh

