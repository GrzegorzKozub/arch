#!/bin/sh

RESOLUTION=$(xrandr | grep "*" | sed -n -e "s/^   //p" | sed -n -e "s/     .*$//p")
WIDTH=$(echo $RESOLUTION | cut -dx -f1)
HEIGHT=$(echo $RESOLUTION | cut -dx -f2)

function fix() {
  local windows=$(xdotool search --name "$1")
  [[ -z $ids ]] || while IFS= read -r window; do
    xdotool windowsize $window $2 $3
    xdotool windowmove $window $4 $5
  done <<< $windows
}

fix ".+Chromium" $(( $WIDTH - 400 )) $(( $HEIGHT - 250 )) 200 $(( 125 + 32 ))
fix ".+Code" $(( $WIDTH - 400 )) $(( $HEIGHT - 250 )) 200 $(( 125 + 32 ))
fix ".+Azure Data Studio" $(( $WIDTH - 400 )) $(( $HEIGHT - 250 )) 200 $(( 125 + 32 ))
fix ".+Slack" $(( $WIDTH - 400 )) $(( $HEIGHT - 250 - 57 )) 200 $(( 125 + 32 ))
fix ".+Postman" $(( $WIDTH - 400 )) $(( $HEIGHT - 250 - 57 )) 200 $(( 125 + 32 ))
fix ".+ - KeePassXC" 1600 1284 800 318

unset RESOLUTION WIDTH HEIGHT

