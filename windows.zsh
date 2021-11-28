#!/usr/bin/env zsh

# xdotool selectwindow getwindowgeometry

() {

  local res=$(xrandr | grep "*" | head -n 1 | sed -n -e "s/^ *//p" | sed -n -e "s/ .*$//p")
  local width=$(echo $res | cut -dx -f1)
  local height=$(echo $res | cut -dx -f2)
  local theme=$(gsettings get org.gnome.desktop.interface gtk-theme)

  function fix {
    local windows=$(xdotool search --onlyvisible --maxdepth 2 --name --class "$1")
    [[ -z $windows ]] || while IFS= read -r window; do
      # xdotool windowstate --remove MAXIMIZED_HORZ $window
      # xdotool windowstate --remove MAXIMIZED_VERT $window
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

  [[ $width = 3840 ]] && [[ $height = 2400 ]] && {

    if [[ $theme =~ "Adwaita" ]]; then local top_bar=80; local title_bar=73
    elif [[ $theme =~ "Arc" ]]; then local top_bar=78; local title_bar=57
    elif [[ $theme =~ "Materia" ]]; then local top_bar=64; local title_bar=71
    else exit 1; fi

    function big { center $1 7.0 14.5 $2 $3 $4 $5 }
    function medium { center $1 6 12.5 $2 $3 $4 $5 }
    function small { center $1 5.0 10.5 $2 $3 $4 $5 }
  }

  [[ $width = 3840 ]] && [[ $height = 2160 ]] && {

    if [[ $theme =~ "Adwaita" ]]; then local top_bar=48; local title_bar=37
    elif [[ $theme =~ "Arc" ]]; then local top_bar=47; local title_bar=28
    elif [[ $theme =~ "Materia" ]]; then local top_bar=38; local title_bar=42
    else exit 1; fi

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

  function chromium {
    [[ -v _4k ]] && {
      fix $1 \
        $(( ( $width / 3 ) * 2 )) \
        $(( $height - $margin - $top_bar )) \
        $margin \
        $(( $margin + $top_bar ))
     } || big $1 104 -24 76 -38
  }

  function brave {
    chromium ".?Brave$"
  }

  function chrome {
    chromium ".?Chrom(e|ium)$"
  }

  function slack {
    local title=".?Slack$"
    [[ -v _4k ]] && {
      fix $title \
        $(( ( $width / 7 ) * 3 )) \
        $(( $height - $margin * 6 - $top_bar - $title_bar )) \
        $(( ( $width / 7 ) * 4 - $margin * 3 )) \
        $(( $margin * 3 + $top_bar ))
      } || medium $title $(( - $title_bar ))
  }

  function teams {
    local title="^Microsoft Teams.?"
    [[ -v _4k ]] && {
      fix $title \
        $(( ( $width / 7 ) * 3 )) \
        $(( $height - $margin * 6 - $top_bar )) \
        $(( ( $width / 7 ) * 4 - $margin * 3 )) \
        $(( $margin * 3 + $top_bar ))
      } || medium $title
  }

  function vscode { big ".?Visual Studio Code$" }
  function postman { big_electron "^Postman$" }

  function data_studio { big ".?Azure Data Studio$" }
  function obs { big_qt "^OBS.*Profile.*Scenes.?" }
  function shotcut { big_qt ".?Shotcut$" }

  function foliate { medium "Foliate" }
  function drawing { medium "^Drawing$" }

  function gimp {
    medium "GNU Image Manipulation Program"
    medium ".?GIMP$"
  }

  function keepass { small_qt "KeePassXC$" }

  [[ -z "$1" ]] && {
    brave
    chrome
    slack
    teams
    vscode
    postman
    data_studio
    obs
    shotcut
    drawing
    gimp
    keepass
    foliate
  } || eval $1

} $1

