#!/usr/bin/env zsh

set -e -o verbose

# packages

# sudo pacman -S --noconfirm \
#   mysql-workbench

sudo pacman -S --noconfirm \
  jre-openjdk \
  dbeaver

CFG=/usr/share/dbeaver/dbeaver.ini
OPT=-Dosgi.configuration.area
[[ $(grep $OPT $CFG) ]] || {
  echo "$OPT=@user.home/.local/share/DBeaver" | sudo tee --append $CFG > /dev/null
}

# https://github.com/dbeaver/dbeaver/issues/20704

# links

# cp /usr/share/applications/mysql-workbench.desktop $XDG_DATA_HOME/applications
# sed -i -e 's/^Name=.*/Name=MySQL/' $XDG_DATA_HOME/applications/mysql-workbench.desktop

cp /usr/share/applications/io.dbeaver.DBeaver.desktop $XDG_DATA_HOME/applications
sed -i -e 's/^Name=.*/Name=DBeaver/' $XDG_DATA_HOME/applications/io.dbeaver.DBeaver.desktop

# dotfiles

. ~/code/dot/sql.zsh

