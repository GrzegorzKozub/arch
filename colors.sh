#!/usr/bin/env bash

set -e

if [[ $HOST = 'player' ]]; then
  dispwin -d1 -L
fi

if [[ $HOST = 'worker' ]]; then
  dispwin -d1 -L
  dispwin -d2 -L
fi
