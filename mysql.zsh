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
    mysql:5.7

fi

# packages

sudo pacman -S --noconfirm \
  mysql-workbench

# links

LOCAL=${XDG_DATA_HOME:-~/.local/share}/applications
APP=mysql-workbench.desktop

cp /usr/share/applications/$APP $LOCAL
sed -i -e 's/^Name=MySQL Workbench$/Name=MySQL/' $LOCAL/$APP

# dotfiles

. ~/code/dotfiles/mysql.zsh

