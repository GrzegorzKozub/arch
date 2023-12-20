#!/usr/bin/env zsh

set -e -o verbose

# config

LOCAL=0

# local

if [[ $LOCAL = 1 ]]; then

  docker run \
    --detach \
    --env MYSQL_ALLOW_EMPTY_PASSWORD=1 \
    --name mysql \
    -p 3306:3306 \
    mysql

fi

# packages

# sudo pacman -S --noconfirm \
#   mysql-workbench

sudo pacman -S --noconfirm \
  jre-openjdk dbeaver

CFG=/usr/share/dbeaver/dbeaver.ini
OPT=-Dosgi.configuration.area
[[ $(grep $OPT $CFG) ]] || {
  echo "$OPT=@user.home/.local/share/DBeaver" | sudo tee --append $CFG > /dev/null
}

# https://github.com/dbeaver/dbeaver/issues/20704

# links

# cp /usr/share/applications/mysql-workbench.desktop $XDG_DATA_HOME/applications
# sed -i -e 's/^Name=MySQL Workbench$/Name=MySQL/' $XDG_DATA_HOME/applications/mysql-workbench.desktop

cp /usr/share/applications/io.dbeaver.DBeaver.desktop $XDG_DATA_HOME/applications
sed -i -e 's/^Name=DBeaver Community$/Name=DBeaver/' $XDG_DATA_HOME/applications/io.dbeaver.DBeaver.desktop

# dotfiles

# . ~/code/dotfiles/mysql.zsh

