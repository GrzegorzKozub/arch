#!/bin/sh

eval $1 &

xprop -spy -root _NET_ACTIVE_WINDOW |
  grep --line-buffered --only-matching '0[xX][a-zA-Z0-9]\{7\}' |
  while read -r id; do
    if [[ $(xprop -id $id WM_CLASS) =~ $2 ]]; then
      sleep 5
      `dirname $0`/windows.zsh $2
      killall xprop
    fi
  done

