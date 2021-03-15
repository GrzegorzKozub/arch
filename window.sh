#!/bin/sh

$1 &

xprop -spy -root _NET_ACTIVE_WINDOW |
  grep --line-buffered --only-matching '0[xX][a-zA-Z0-9]\{7\}' |
  while read -r id; do
    if [[ $(xprop -id $id WM_CLASS) =~ $2 ]]; then
      `dirname $0`/windows.zsh
      killall xprop
    fi
  done

