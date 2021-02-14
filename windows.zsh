#!/usr/bin/env zsh

RESOLUTION=$(xrandr | grep "*" | sed -n -e "s/^   //p" | sed -n -e "s/     .*$//p")
WIDTH=$(echo $RESOLUTION | cut -dx -f1)
HEIGHT=$(echo $RESOLUTION | cut -dx -f2)
THEME=$(gsettings get org.gnome.desktop.interface gtk-theme)

function fix() {
  local windows=$(xdotool search --name --class "$1")
  [[ -z $windows ]] || while IFS= read -r window; do
    xdotool windowsize $window $2 $3
    xdotool windowmove $window $4 $5
  done <<< $windows
}

[[ $WIDTH = 3200 ]] && [[ $HEIGHT = 1800 ]] && {

  if [[ $THEME =~ "Arc" ]]; then PANEL=64; ELECTRON=57
  elif [[ $THEME =~ "Materia" ]]; then PANEL=68; ELECTRON=71
  else exit 1; fi

  function center() {
    fix "$1" \
      $(( ( $WIDTH / 8 ) * 7 )) \
      $(( ( ( $HEIGHT - $PANEL ) / 8 ) * 7 - ${2:-0} )) \
      $(( $WIDTH / ( 8 * 2 ) )) \
      $(( ( $HEIGHT - $PANEL ) / ( 8 * 2 ) + $PANEL ))
  }

  center ".?Chrom"
  center ".?Visual Studio Code"
  center ".?Azure Data Studio"

  center ".?Slack" $ELECTRON
  center ".?Postman" $ELECTRON

  fix ".? - KeePassXC" 1600 1284 800 318
}

[[ $WIDTH = 3840 ]] && [[ $HEIGHT = 2160 ]] && {

  if [[ $THEME =~ "Arc" ]]; then PANEL=47; ELECTRON=28
  elif [[ $THEME =~ "Materia" ]]; then PANEL=38; ELECTRON=42
  else exit 1; fi

  MARGIN=25

  fix ".?Chrom" \
    $(( ( $WIDTH / 5 ) * 3 )) \
    $(( $HEIGHT - $MARGIN * 2 - $PANEL )) \
    $MARGIN \
    $(( $MARGIN + $PANEL ))

  fix ".?Slack" \
    $(( $WIDTH / 2 )) \
    $(( $HEIGHT - $MARGIN * 4 - $PANEL - $ELECTRON )) \
    $(( $WIDTH / 2 - $MARGIN * 2 )) \
    $(( $MARGIN * 2 + $PANEL ))

  function center() {
    fix "$1" \
      $(( ( $WIDTH / 4 ) * 3 )) \
      $(( ( ( $HEIGHT - $PANEL ) / 8 ) * 7 )) \
      $(( $WIDTH / ( 4 * 2 ) )) \
      $(( ( $HEIGHT - $PANEL ) / ( 8 * 2 ) + $PANEL ))
  }

  center ".?Visual Studio Code"
  center ".?Azure Data Studio"

  fix ".?Postman" \
    $(( ( $WIDTH / 5 ) * 3 )) \
    $(( ( ( $HEIGHT - $PANEL ) / 8 ) * 6 - $ELECTRON )) \
    $(( $WIDTH / 5 )) \
    $(( ( $HEIGHT - $PANEL ) / 8 + $PANEL ))

  fix ".? - KeePassXC" 1200 964 1320 635
}

unset RESOLUTION WIDTH HEIGHT THEME MARGIN PANEL ELECTRON
