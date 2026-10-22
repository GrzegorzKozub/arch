#!/usr/bin/env bash
set -eo pipefail -ux

running() {
  if pgrep -x "$1" > /dev/null; then
    echo "$1 is running, skipping" >&2
    return 0
  fi
  return 1
}

# brave

if ! running 'brave.*'; then
  for PROFILE in "$XDG_CACHE_HOME"/BraveSoftware/Brave-Origin/{Default,Profile\ [0-9]*}; do
    [[ -d $PROFILE ]] || continue
    rm -rf "$PROFILE"/{Cache,'Code Cache'}
  done
fi

# postman

if ! running 'Postman'; then
  rm -rf "$XDG_CONFIG_HOME"/Postman/{,Partitions/*/}{Cache,'Code Cache','Service Worker'}
fi

# teams

if ! running 'teams-for-linux'; then
  rm -rf "$XDG_CONFIG_HOME"/teams-for-linux/Partitions/*/{Cache,'Code Cache'}
fi

# tidal

if ! running 'tidal-hifi'; then
  rm -rf "$XDG_CONFIG_HOME"/tidal-hifi/{Cache,'Code Cache'}
fi
