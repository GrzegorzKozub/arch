#!/usr/bin/env zsh

RESOLUTION=$(xrandr | grep "*" | sed -n -e "s/^   //p" | sed -n -e "s/     .*$//p")
WIDTH=$(echo $RESOLUTION | cut -dx -f1)
HEIGHT=$(echo $RESOLUTION | cut -dx -f2)

THEME=$(gsettings get org.gnome.desktop.interface gtk-theme)

CHROME=".?Chrom(e|ium)$"
VSCODE=".?Visual Studio Code$"
DATASTUDIO=".?Azure Data Studio$"
OBS="^OBS.*Profile.*Scenes.?"
SHOTCUT=".?Shotcut$"
SLACK=".?Slack$"
POSTMAN="^Postman$"
KEEPASS=".? - KeePassXC$"

function fix() {
  local windows=$(xdotool search --onlyvisible --maxdepth 2 --name --class "$1")
  [[ -z $windows ]] || while IFS= read -r window; do
    xdotool windowsize $window $2 $3
    xdotool windowmove $window $4 $5
  done <<< $windows
}

[[ $WIDTH = 3200 ]] && [[ $HEIGHT = 1800 ]] && {

  if [[ $THEME =~ "Arc" ]]; then TOP_BAR=64; TITLE_BAR=57
  elif [[ $THEME =~ "Materia" ]]; then TOP_BAR=68; TITLE_BAR=71
  else exit 1; fi

  function center() {
    fix "$1" \
      $(( ( $WIDTH / 8 ) * 7 )) \
      $(( ( ( $HEIGHT - $TOP_BAR ) / 8 ) * 7 - ${2:-0} - ${3:-0} )) \
      $(( $WIDTH / ( 8 * 2 ) )) \
      $(( ( $HEIGHT - $TOP_BAR ) / ( 8 * 2 ) + $TOP_BAR + ${3:-0} ))
  }

  center $CHROME

  center $VSCODE
  center $DATASTUDIO

  center $OBS 0 $TITLE_BAR
  center $SHOTCUT 0 $TITLE_BAR

  center $SLACK $TITLE_BAR
  center $POSTMAN $TITLE_BAR

  fix $KEEPASS 1600 1284 800 318
}

[[ $WIDTH = 3840 ]] && [[ $HEIGHT = 2160 ]] && {

  if [[ $THEME =~ "Arc" ]]; then TOP_BAR=47; TITLE_BAR=28
  elif [[ $THEME =~ "Materia" ]]; then TOP_BAR=38; TITLE_BAR=42
  else exit 1; fi

  MARGIN=25

  fix $CHROME \
    $(( ( $WIDTH / 5 ) * 3 )) \
    $(( $HEIGHT - $MARGIN * 2 - $TOP_BAR )) \
    $MARGIN \
    $(( $MARGIN + $TOP_BAR ))

  fix $SLACK \
    $(( $WIDTH / 2 )) \
    $(( $HEIGHT - $MARGIN * 4 - $TOP_BAR - $TITLE_BAR )) \
    $(( $WIDTH / 2 - $MARGIN * 2 )) \
    $(( $MARGIN * 2 + $TOP_BAR ))

  function center() {
    fix "$1" \
      $(( ( $WIDTH / 4 ) * 3 )) \
      $(( ( ( $HEIGHT - $TOP_BAR ) / 8 ) * 7 )) \
      $(( $WIDTH / ( 4 * 2 ) )) \
      $(( ( $HEIGHT - $TOP_BAR ) / ( 8 * 2 ) + $TOP_BAR ))
  }

  center $VSCODE
  center $DATASTUDIO

  center $OBS
  center $SHOTCUT

  fix $POSTMAN \
    $(( ( $WIDTH / 5 ) * 3 )) \
    $(( ( ( $HEIGHT - $TOP_BAR ) / 8 ) * 6 - $TITLE_BAR )) \
    $(( $WIDTH / 5 )) \
    $(( ( $HEIGHT - $TOP_BAR ) / 8 + $TOP_BAR ))

  fix $KEEPASS 1200 964 1320 635
}

unset RESOLUTION WIDTH HEIGHT \
  THEME \
  CHROME VSCODE DATASTUDIO OBS SHOTCUT POSTMAN KEEPASS \
  MARGIN TOP_BAR TITLE_BAR
