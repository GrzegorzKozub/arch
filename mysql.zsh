#!/usr/bin/env zsh

set -e -o verbose

# mysql

NAME=mysql

if [[ $(docker ps --all --filter name=$NAME --quiet) ]]; then

  docker start $NAME

else

  docker run \
    --detach \
    --name $NAME \
    --env MYSQL_ALLOW_EMPTY_PASSWORD=1 \
    --publish 3306:3306 \
    mysql

fi

