#!/usr/bin/env zsh

# xdotool selectwindow getwindowgeometry

() {

# local res=$(xrandr | grep "*" | head -n 1 | sed -n -e "s/^ *//p" | sed -n -e "s/ .*$//p")

local desktop=$(xprop -root | grep -e 'NET_WORKAREA(CARDINAL)' | sed -e 's/.*=//' )

local left=$(echo $desktop | cut -d ',' -f1 | sed -e 's/ //')
local top=$(echo $desktop | cut -d ',' -f2 | sed -e 's/ //')
local width=$(echo $desktop | cut -d ',' -f3 | sed -e 's/ //')
local height=$(echo $desktop | cut -d ',' -f4 | sed -e 's/ //')

[[ $(xrandr | grep "*" | wc -l) = 2 ]] && local dual=true
[[ $dual ]] && width=$(( $width / 2 ))

function fix {
  local windows=$(xdotool search --onlyvisible --maxdepth 2 --name --class "$1")
  [[ -z $windows ]] || while IFS= read -r window; do
    xdotool windowsize $window $2 $3
    xdotool windowmove $window $4 $5
  done <<< $windows
}

function center {
  local width_step=8; local height_step=16
  fix "$1" \
    $(( ( $width / $width_step ) * $2 + ${6:-0} )) \
    $(( ( ( $height - $top_bar ) / $height_step ) * $3 + ${4:-0} )) \
    $(( ( $width / $width_step ) * ( ( $width_step - $2 ) / 2 ) + ${7:-0} )) \
    $(( ( ( $height - $top_bar ) / $height_step ) * ( ( $height_step - $3 ) / 2 ) + $top_bar + ${5:-0} ))
}

function push {
  local windows=$(xdotool search --onlyvisible --maxdepth 2 --name --class "$1")
  [[ -z $windows ]] || while IFS= read -r window; do
    local left=$(xdotool getwindowgeometry --shell $window | grep "X=" | cut -d= -f2)
    local top=$(xdotool getwindowgeometry --shell $window | grep "Y=" | cut -d= -f2)
    xdotool windowmove $window $(( $left + $width )) $top
  done <<< $windows
}

function unmax {
  local windows=$(xdotool search --onlyvisible --maxdepth 2 --name --class "$1")
  [[ -z $windows ]] || while IFS= read -r window; do
    xdotool windowstate --remove MAXIMIZED_HORZ $window
    xdotool windowstate --remove MAXIMIZED_VERT $window
  done <<< $windows
}

[[ $width = 3840 ]] && [[ $height = 2400 ]] && {
  local top_bar=80; local title_bar=73
  function big { center $1 7.0 14.5 $2 $3 $4 $5 }
  function medium { center $1 6 12.5 $2 $3 $4 $5 }
  function small { center $1 5.0 10.5 $2 $3 $4 $5 }
}

[[ $width = 3840 ]] && [[ $height = 2160 ]] && {
  local top_bar=48; local title_bar=37
  local _4k=true
  local margin=25
  function big { center $1 6 14 $2 $3 $4 $5 }
  function medium { center $1 4.5 12 $2 $3 $4 $5 }
  function small { center $1 3.0 10 $2 $3 $4 $5 }
}

function big_electron { big $1 $(( - $title_bar )) }
function big_qt { big $1 $(( - $title_bar )) $title_bar }

function medium_electron { medium $1 $(( - $title_bar )) }
function medium_qt { medium $1 $(( - $title_bar )) $title_bar }

function small_electron { small $1 $(( - $title_bar )) }
function small_qt { small $1 $(( - $title_bar )) $title_bar }

function brave {
  local title=".?Brave$"
  unmax $title && sleep 0.1
  [[ -v _4k ]] && big $title 63 -15 47 -24 || big $title 104 -24 76 -38
}

function vscode { big ".?Visual Studio Code$" }
function postman { big_electron "^Postman$" }
function data_studio { big ".?Azure Data Studio$" }
function mysql_workbench { big ".?MySQL Workbench$" }
function obs { big_qt "^OBS.*Profile.*Scenes.?" }
function shotcut { big_qt ".?Shotcut$" }

function slack { medium ".?Slack$" $(( - $title_bar )) }
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

