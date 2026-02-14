#!/usr/bin/env bash
set -eo pipefail -ux

# dynamodb

NAME=dynamodb

if [[ $(docker ps --all --filter name=$NAME --quiet) ]]; then

  docker start $NAME

else

  docker run \
    --detach \
    --name $NAME \
    --env PERSISTENCE=1 \
    --env SERVICES=dynamodb \
    --publish 127.0.0.1:4566:4566 \
    --publish 127.0.0.1:4510-4559:4510-4559 \
    localstack/localstack

fi
