#!/bin/sh

set -e

[[ $HOSTNAME = 'drifter' ]] && dispwin -d1 -L
[[ $HOSTNAME = 'worker' ]] && dispwin -d1 -L && dispwin -d2 -L

