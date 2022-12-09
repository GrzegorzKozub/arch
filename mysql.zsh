#!/usr/bin/env zsh

set -e -o verbose

# config

LOCAL=0

# mysql

if [[ $LOCAL = 1 ]]; then

  docker run \
    --detach \
    --env MYSQL_ALLOW_EMPTY_PASSWORD=1 \
    --name mysql \
    -p 3306:3306 \
    mysql:5.7

fi

# mysql-workbench

sudo pacman -S --noconfirm \
  mysql-workbench

# links

for APP in \
  mysql-workbench
do
  cp /usr/share/applications/$APP.desktop ~/.local/share/applications
  sed -i 's/^Name=MySQL Workbench$/Name=MySQL/' \
    ~/.local/share/applications/$APP.desktop
done

# dotfiles

. ~/code/dotfiles/mysql.zsh

