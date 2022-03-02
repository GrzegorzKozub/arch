#!/usr/bin/env zsh

() {

# local res=$(xrandr | grep "*" | head -n 1 | sed -n -e "s/^ *//p" | sed -n -e "s/ .*$//p")

local desktop=$(xprop -root | grep -e 'NET_WORKAREA(CARDINAL)' | sed -e 's/.*=//' )

local left=$(echo $desktop | cut -d ',' -f1 | sed -e 's/ //')
local top=$(echo $desktop | cut -d ',' -f2 | sed -e 's/ //')
local width=$(echo $desktop | cut -d ',' -f3 | sed -e 's/ //')
local height=$(echo $desktop | cut -d ',' -f4 | sed -e 's/ //')

[[ $(xrandr | grep "*" | wc -l) = 2 ]] && local dual=true
[[ $dual ]] && width=$(( $width / 2 ))

function move { # window, width, height, left, top
  local windows=$(xdotool search --onlyvisible --maxdepth 2 --name --class "$1")
  [[ -z $windows ]] || while IFS= read -r window; do
    xdotool windowsize $window $2 $3
    xdotool windowmove $window $4 $5
  done <<< $windows
}

function center { # window, width, height, width patch, height patch, left patch, top patch
  local width_step=8; local height_step=16
  move "$1" \
    $(( ( $width / $width_step ) * $2 + ${4:-0} )) \
    $(( ( $height / $height_step ) * $3 + ${5:-0} )) \
    $(( ( $width / $width_step ) * ( ( $width_step - $2 ) / 2 ) + $left + ${6:-0} )) \
    $(( ( $height / $height_step ) * ( ( $height_step - $3 ) / 2 ) + $top + ${7:-0} ))
}

function unmax { # window
  local windows=$(xdotool search --onlyvisible --maxdepth 2 --name --class "$1")
  [[ -z $windows ]] || while IFS= read -r window; do
    xdotool windowstate --remove MAXIMIZED_HORZ $window
    xdotool windowstate --remove MAXIMIZED_VERT $window
  done <<< $windows
  xdotool windowraise $(xdotool getactivewindow)
}

[[ $width = 3840 ]] && [[ $height = 2320 ]] && {
  local title_bar=73
  function big { center $1 7.0 14.5 $2 $3 $4 $5 } # window, width patch, height patch, left patch, top patch
  function medium { center $1 6.0 12.5 $2 $3 $4 $5 }
  function small { center $1 5.0 10.5 $2 $3 $4 $5 }
}

[[ $width = 3840 ]] && [[ $height = 2080 ]] && {
  local title_bar=37; local uhd=true
  function big { center $1 6.0 14.0 $2 $3 $4 $5 }
  function medium { center $1 4.5 12.0 $2 $3 $4 $5 }
  function small { center $1 3.0 10.0 $2 $3 $4 $5 }
}

function big_electron { big $1 0 $(( - $title_bar )) }
function big_qt { big $1 0 $(( - $title_bar )) 0 $title_bar }

function medium_electron { medium $1 0 $(( - $title_bar )) }
function medium_qt { medium $1 0 $(( - $title_bar )) 0 $title_bar }

function small_electron { small $1 0 $(( - $title_bar )) }
function small_qt { small $1 0 $(( - $title_bar )) 0 $title_bar }

function brave {
  local title=".?Brave$"
  unmax $title && sleep 0.1
  [[ -v uhd ]] && big $title 63 -15 47 -24 || big $title 80 100 -40 -22
}

function vscode { big ".?Visual Studio Code$" }
function postman { big_electron "^Postman$" }
function data_studio { big ".?Azure Data Studio$" }
function mysql_workbench { big ".?MySQL Workbench$" }
function obs { big_qt "^OBS.*Profile.*Scenes.?" }
function shotcut { big_qt ".?Shotcut$" }

function slack { medium_electron ".?Slack$" }
function foliate { medium "Foliate" }

function gimp {
  medium "GNU Image Manipulation Program"
  medium ".?GIMP$"
}

function keepass { small_qt "KeePassXC$" }
function pinta { small ".?Pinta$" }

[[ -z "$1" ]] && {
  brave
  vscode
  postman
  data_studio
  mysql_workbench
  obs
  shotcut
  slack
  foliate
  gimp
  keepass
  pinta
} || eval $1

} $1

