#!/usr/bin/env zsh

function windows {
  local res=$(xrandr | grep "*" | sed -n -e "s/^   //p" | sed -n -e "s/     .*$//p")
  local width=$(echo $res | cut -dx -f1)
  local height=$(echo $res | cut -dx -f2)

  local theme=$(gsettings get org.gnome.desktop.interface gtk-theme)

  local chrome=".?Chrom(e|ium)$"
  local vscode=".?Visual Studio Code$"
  local data_studio=".?Azure Data Studio$"
  local obs="^OBS.*Profile.*Scenes.?"
  local shotcut=".?Shotcut$"
  local slack=".?Slack$"
  local postman="^Postman$"
  local keepass=".? - KeePassXC$"

  function fix {
    local windows=$(xdotool search --onlyvisible --maxdepth 2 --name --class "$1")
    [[ -z $windows ]] || while IFS= read -r window; do
      xdotool windowsize $window $2 $3
      xdotool windowmove $window $4 $5
    done <<< $windows
  }

  [[ $width = 3200 ]] && [[ $height = 1800 ]] && {

    if [[ $theme =~ "Arc" ]]; then local top_bar=64; local title_bar=57
    elif [[ $theme =~ "Materia" ]]; then local top_bar=68; local title_bar=71
    else exit 1; fi

    function center {
      fix "$1" \
        $(( ( $width / 8 ) * 7 )) \
        $(( ( ( $height - $top_bar ) / 8 ) * 7 - ${2:-0} - ${3:-0} )) \
        $(( $width / ( 8 * 2 ) )) \
        $(( ( $height - $top_bar ) / ( 8 * 2 ) + $top_bar + ${3:-0} ))
    }

    center $chrome

    center $vscode
    center $data_studio

    center $obs 0 $title_bar
    center $shotcut 0 $title_bar

    center $slack $title_bar
    center $postman $title_bar

    fix $keepass 1600 1284 800 318
  }

  [[ $width = 3840 ]] && [[ $height = 2160 ]] && {

    if [[ $theme =~ "Arc" ]]; then local top_bar=47; local title_bar=28
    elif [[ $theme =~ "Materia" ]]; then local top_bar=38; local title_bar=42
    else exit 1; fi

    MARGIN=25

    fix $chrome \
      $(( ( $width / 5 ) * 3 )) \
      $(( $height - $MARGIN * 2 - $top_bar )) \
      $MARGIN \
      $(( $MARGIN + $top_bar ))

    fix $slack \
      $(( $width / 2 )) \
      $(( $height - $MARGIN * 4 - $top_bar - $title_bar )) \
      $(( $width / 2 - $MARGIN * 2 )) \
      $(( $MARGIN * 2 + $top_bar ))

    function center {
      fix "$1" \
        $(( ( $width / 4 ) * 3 )) \
        $(( ( ( $height - $top_bar ) / 8 ) * 7 )) \
        $(( $width / ( 4 * 2 ) )) \
        $(( ( $height - $top_bar ) / ( 8 * 2 ) + $top_bar ))
    }

    center $vscode
    center $data_studio

    center $obs
    center $shotcut

    fix $postman \
      $(( ( $width / 5 ) * 3 )) \
      $(( ( ( $height - $top_bar ) / 8 ) * 6 - $title_bar )) \
      $(( $width / 5 )) \
      $(( ( $height - $top_bar ) / 8 + $top_bar ))

    fix $keepass 1200 964 1320 635
  }
}

windows

