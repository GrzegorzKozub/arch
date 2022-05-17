#!/bin/sh

set -e

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

