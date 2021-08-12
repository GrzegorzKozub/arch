#!/usr/bin/env zsh

# xdotool selectwindow getwindowgeometry

() {

  local res=$(xrandr | grep "*" | sed -n -e "s/^ *//p" | sed -n -e "s/ .*$//p")
  local width=$(echo $res | cut -dx -f1)
  local height=$(echo $res | cut -dx -f2)
  local theme=$(gsettings get org.gnome.desktop.interface gtk-theme)

  function fix {
    local windows=$(xdotool search --onlyvisible --maxdepth 2 --name --class "$1")
    [[ -z $windows ]] || while IFS= read -r window; do
      xdotool windowsize $window $2 $3
      xdotool windowmove $window $4 $5
    done <<< $windows
  }

  [[ $width = 3840 ]] && [[ $height = 2400 ]] && {

    if [[ $theme =~ "Adwaita" ]]; then local top_bar=67; local title_bar=73
    elif [[ $theme =~ "Arc" ]]; then local top_bar=67; local title_bar=57
    elif [[ $theme =~ "Materia" ]]; then local top_bar=68; local title_bar=71
    else exit 1; fi

    function center {
      fix "$1" \
        $(( ( $width / 10 ) * 9 )) \
        $(( ( ( $height - $top_bar ) / 10 ) * 9 - ${2:-0} - ${3:-0} )) \
        $(( $width / ( 10 * 2 ) )) \
        $(( ( $height - $top_bar ) / ( 10 * 2 ) + $top_bar + ${3:-0} ))
    }
  }

  [[ $width = 3840 ]] && [[ $height = 2160 ]] && {

    if [[ $theme =~ "Adwaita" ]]; then local top_bar=48; local title_bar=37
    elif [[ $theme =~ "Arc" ]]; then local top_bar=47; local title_bar=28
    elif [[ $theme =~ "Materia" ]]; then local top_bar=38; local title_bar=42
    else exit 1; fi

    local _4k=true
    local margin=25

    function big {
      fix "$1" \
        $(( ( $width / 8 ) * 6 )) \
        $(( ( ( $height - $top_bar ) / 16 ) * 14 - ${2:-0} )) \
        $(( ( $width / 8 ) * 1 )) \
        $(( ( ( $height - $top_bar ) / 16 ) * 1 + $top_bar + ${3:-0} ))
    }

    function big_electron { big $1 $title_bar }
    function big_qt { big $1 $title_bar $title_bar }

    function medium {
      fix "$1" \
        $(( ( $width / 8 ) * 4.5 )) \
        $(( ( ( $height - $top_bar ) / 16 ) * 12 - ${2:-0} )) \
        $(( ( $width / 8 ) * 1.75 )) \
        $(( ( ( $height - $top_bar ) / 16 ) * 2  + $top_bar + ${3:-0} ))
    }

    function medium_electron { medium $1 $title_bar }
    function medium_qt { medium $1 $title_bar $title_bar }

    function small {
      fix "$1" \
        $(( ( $width / 8 ) * 3 )) \
        $(( ( ( $height - $top_bar ) / 16 ) * 10 - ${2:-0} )) \
        $(( ( $width / 8 ) * 2.5 )) \
        $(( ( ( $height - $top_bar ) / 16 ) * 3  + $top_bar + ${3:-0} ))
    }

    function small_electron { small $1 $title_bar }
    function small_qt { small $1 $title_bar $title_bar }
  }

  function chrome {
    local title=".?Chrom(e|ium)$"
    [[ -v _4k ]] && {
      fix $title \
        $(( ( $width / 5 ) * 3 )) \
        $(( $height - $margin * 2 - $top_bar )) \
        $margin \
        $(( $margin + $top_bar ))
     } || center $title
  }

  function slack {
    local title=".?Slack$"
    [[ -v _4k ]] && {
      fix $title \
        $(( $width / 2 )) \
        $(( $height - $margin * 4 - $top_bar - $title_bar )) \
        $(( $width / 2 - $margin * 2 )) \
        $(( $margin * 2 + $top_bar ))
    } || center $title $title_bar
  }

  function vscode { big ".?Visual Studio Code$" }
  function postman { big_electron "^Postman$" }

  function data_studio { big ".?Azure Data Studio$" }
  function obs { big_qt "^OBS.*Profile.*Scenes.?" }
  function shotcut { big_qt ".?Shotcut$" }

  function keepass {
    local title=".? - KeePassXC$"
    [[ -v _4k ]] && small_qt $title || fix $title 1800 1550 1020 494
  }

  [[ -z "$1" ]] && {
    chrome
    slack
    keepass
    vscode
    postman
    data_studio
    obs
    shotcut
  } || eval $1

} $1

