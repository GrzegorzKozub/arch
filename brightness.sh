#!/usr/bin/env bash
set -eo pipefail -u

[[ ${1:-} == 'down' ]] && DELTA='5%-'
[[ ${1:-} == 'up' ]] && DELTA='+5%'

[[ -v DELTA ]] || exit 0

brightnessctl set "$DELTA" | grep -o '[0-9]\{1,3\}%' | sed 's/%//'
