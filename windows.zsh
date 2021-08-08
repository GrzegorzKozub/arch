#!/usr/bin/env zsh

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

  [[ $width = 3200 ]] && [[ $height = 1800 ]] && {

    if [[ $theme =~ "Adwaita" ]]; then local top_bar=64; local title_bar=73
    elif [[ $theme =~ "Arc" ]]; then local top_bar=64; local title_bar=57
    elif [[ $theme =~ "Materia" ]]; then local top_bar=68; local title_bar=71
    else exit 1; fi

    function center {
      fix "$1" \
        $(( ( $width / 8 ) * 7 )) \
        $(( ( ( $height - $top_bar ) / 8 ) * 7 - ${2:-0} - ${3:-0} )) \
        $(( $width / ( 8 * 2 ) )) \
        $(( ( $height - $top_bar ) / ( 8 * 2 ) + $top_bar + ${3:-0} ))
    }
  }

  [[ $width = 3840 ]] && [[ $height = 2160 ]] && {

    if [[ $theme =~ "Adwaita" ]]; then local top_bar=48; local title_bar=37
    elif [[ $theme =~ "Arc" ]]; then local top_bar=47; local title_bar=28
    elif [[ $theme =~ "Materia" ]]; then local top_bar=38; local title_bar=42
    else exit 1; fi

    local _4k=true
    local margin=25

    function center {
      fix "$1" \
        $(( ( $width / 4 ) * 3 )) \
        $(( ( ( $height - $top_bar ) / 8 ) * 7 )) \
        $(( $width / ( 4 * 2 ) )) \
        $(( ( $height - $top_bar ) / ( 8 * 2 ) + $top_bar ))
    }
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

  function data_studio { center ".?Azure Data Studio$" }

  function keepass {
    local title=".? - KeePassXC$"
    [[ -v _4k ]] && fix $title 1200 964 1320 640 || fix $title 1600 1284 800 324
  }

  function obs {
    local title="^OBS.*Profile.*Scenes.?"
    [[ -v _4k ]] && center $title || center $title 0 $title_bar
  }

  function postman {
    local title="^Postman$"
    [[ -v _4k ]] && {
      fix $title \
        $(( ( $width / 5 ) * 3 )) \
        $(( ( ( $height - $top_bar ) / 8 ) * 6 - $title_bar )) \
        $(( $width / 5 )) \
        $(( ( $height - $top_bar ) / 8 + $top_bar ))
    } || center $title $title_bar
  }

  function shotcut {
    local title=".?Shotcut$"
    [[ -v _4k ]] && center $title || center $title 0 $title_bar
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

  function vscode { center ".?Visual Studio Code$" }

  [[ -z "$1" ]] && {
    chrome
    data_studio
    keepass
    obs
    postman
    shotcut
    slack
    vscode
  } || eval $1

} $1

