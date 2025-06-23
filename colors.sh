#!/usr/bin/env bash

set -e

if [[ $HOSTNAME =~ ^(player|worker)$ ]]; then
  dispwin -d1 -L
fi

if [[ $HOSTNAME = 'sacrifice' ]]; then
  dispwin -d1 -L
  dispwin -d2 -L
fi

