#!/bin/sh

set -e

if [[ $HOSTNAME = 'player' ]]; then
  dispwin -d1 -L
fi

if [[ $HOSTNAME = 'worker' ]]; then
  dispwin -d1 -L
  dispwin -d2 -L
fi

