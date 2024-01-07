#!/usr/bin/env bash

set -e

[ "${FLOCKER}" != "$0" ] && exec env FLOCKER="$0" flock -E 0 -en "$0" "$0" "$@" || :

wait_net() {
  until [[
    $(ping -c 1 -t 32 'github.com' 2> /dev/null |
      grep '1 received') \
  ]]; do
    local waited=1
    sleep 15
  done
  [ -z ${waited+x} ] || sleep 15
}

wait_net

pushd ~/code/walls && ./sync.sh && popd &
pushd ~/code/history && ./sync.sh && popd &
pushd ~/code/keys && ./sync.sh && popd &
pushd ~/code/passwords && ./sync.sh && popd &
pushd ~/code/notes && ./sync.sh && popd &
pushd ~/code/apsis && ./sync.sh && popd &

wait

