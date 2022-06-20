#!/usr/bin/env zsh

set -e -o verbose

# https://wallhaven.cc/help/api
# https://wallhaven.cc/w/g7lyd7
# https://wallhaven.cc/w/735k2e

curl 'https://wallhaven.cc/api/v1/search?q=From%20Software&purity=sfw&sorting=toplist&apikey=lw8CJsACiTynhWyjHGIdX0gdNjT5exts' | jq

