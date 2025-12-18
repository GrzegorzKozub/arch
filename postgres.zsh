#!/usr/bin/env zsh

set -e -o verbose

# postgres

NAME=postgres

if [[ $(docker ps --all --filter name=$NAME --quiet) ]]; then

  docker start $NAME

else

  docker run \
    --detach \
    --name $NAME \
    --env POSTGRES_PASSWORD=postgres \
    --publish 5432:5432 \
    postgres:alpine

fi

