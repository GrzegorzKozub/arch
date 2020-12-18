#!/bin/sh

RESOLUTION=$(xrandr | grep "*" | sed -n -e "s/^   //p" | sed -n -e "s/     .*$//p")
WIDTH=$(echo $RESOLUTION | cut -dx -f1)
HEIGHT=$(echo $RESOLUTION | cut -dx -f2)

function fix() {
  local windows=$(xdotool search --name --class "$1")
  [[ -z $windows ]] || while IFS= read -r window; do
    xdotool windowsize $window $2 $3
    xdotool windowmove $window $4 $5
  done <<< $windows
}

[[ $WIDTH = 3200 ]] && [[ $HEIGHT = 1800 ]] && {
  fix ".?Chromium" $(( $WIDTH - 400 )) $(( $HEIGHT - 250 )) 200 $(( 125 + 32 ))
  fix ".?Visual Studio Code" $(( $WIDTH - 400 )) $(( $HEIGHT - 250 )) 200 $(( 125 + 32 ))
  fix ".?Azure Data Studio" $(( $WIDTH - 400 )) $(( $HEIGHT - 250 )) 200 $(( 125 + 32 ))
  fix ".?Slack" $(( $WIDTH - 400 )) $(( $HEIGHT - 250 - 57 )) 200 $(( 125 + 32 ))
  fix ".?Postman" $(( $WIDTH - 400 )) $(( $HEIGHT - 250 - 57 )) 200 $(( 125 + 32 ))
  fix ".? - KeePassXC" 1600 1284 800 318
}

[[ $WIDTH = 3840 ]] && [[ $HEIGHT = 2160 ]] && {

  MARGIN=25; PANEL=47; ELECTRON=28

  fix ".?Chromium" \
    $(( ( $WIDTH / 5 ) * 3 )) \
    $(( $HEIGHT - $MARGIN * 2 - $PANEL )) \
    $MARGIN \
    $(( $MARGIN + $PANEL ))

  fix ".?Slack" \
    $(( $WIDTH / 2 )) \
    $(( $HEIGHT - $MARGIN * 4 - $PANEL - $ELECTRON )) \
    $(( $WIDTH / 2 - $MARGIN * 2 )) \
    $(( $MARGIN * 2 + $PANEL ))

  fix ".?Visual Studio Code" \
    $(( ( $WIDTH / 4 ) * 3 )) \
    $(( ( ( $HEIGHT - $PANEL ) / 8 ) * 7 )) \
    $(( $WIDTH / ( 4 * 2 ) )) \
    $(( ( $HEIGHT - $PANEL ) / ( 8 * 2 ) + $PANEL ))

  fix ".?Azure Data Studio" \
    $(( ( $WIDTH / 4 ) * 3 )) \
    $(( ( ( $HEIGHT - $PANEL ) / 8 ) * 7 )) \
    $(( $WIDTH / ( 4 * 2 ) )) \
    $(( ( $HEIGHT - $PANEL ) / ( 8 * 2 ) + $PANEL ))

  fix ".?Postman" \
    $(( ( $WIDTH / 5 ) * 3 )) \
    $(( ( ( $HEIGHT - $PANEL ) / 8 ) * 6 - $ELECTRON )) \
    $(( $WIDTH / 5 )) \
    $(( ( $HEIGHT - $PANEL) / 8 + $PANEL ))

  fix ".? - KeePassXC" 1200 964 1320 635
}

unset RESOLUTION WIDTH HEIGHT MARGIN PANEL ELECTRON
