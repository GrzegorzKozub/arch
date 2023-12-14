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

sudo pacman -S --noconfirm \
  mysql-workbench

# links

cp /usr/share/applications/mysql-workbench.desktop $XDG_DATA_HOME/applications
sed -i -e 's/^Name=MySQL Workbench$/Name=MySQL/' $XDG_DATA_HOME/applications/mysql-workbench.desktop

# dotfiles

. ~/code/dotfiles/mysql.zsh

