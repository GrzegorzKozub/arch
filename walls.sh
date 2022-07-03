#!/usr/bin/env bash

set -e -o verbose

# https://wallhaven.cc/help/api
# https://wallhaven.cc/w/g7lyd7
# https://wallhaven.cc/w/735k2e
#curl 'https://wallhaven.cc/api/v1/search?q=From%20Software&purity=sfw&sorting=toplist&apikey=lw8CJsACiTynhWyjHGIdX0gdNjT5exts' |

DIR=${XDG_DATA_HOME:-~/.local/share}/backgrounds

QUERY='like:g7lyd7'
SORTING='relevance'
PAGE=$(shuf -i 1-15 -n 1)
SEARCH="https://wallhaven.cc/api/v1/search?q=$QUERY&sorting=$SORTING&page=$PAGE&apikey=lw8CJsACiTynhWyjHGIdX0gdNjT5exts"

RESULT=$(shuf -i 0-23 -n 1)
URL=$(curl --silent $SEARCH | jq ".data[$RESULT].path" | sed 's/\"//g')

FILE=$(echo $URL | sed 's/.*\///')

[[ ! -f $DIR/$FILE ]] && {
  wget --quiet --directory-prefix $DIR $URL
}

PIC="file:///home/$USER/.local/share/backgrounds/$FILE"

gsettings set org.gnome.desktop.background picture-uri $PIC
gsettings set org.gnome.desktop.background picture-uri-dark $PIC
gsettings set org.gnome.desktop.screensaver picture-uri $PIC

