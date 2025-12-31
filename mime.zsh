#!/usr/bin/env zsh

set -e -o verbose

# default apps

xdg-mime default nvim.desktop application/x-zerosize
xdg-mime default nvim.desktop text/plain

xdg-mime default mpv.desktop audio/mpeg
xdg-mime default mpv.desktop audio/ogg

xdg-mime default mpv.desktop video/mp4
xdg-mime default mpv.desktop video/webm
xdg-mime default mpv.desktop video/x-matroska

xdg-mime default brave-browser.desktop x-scheme-handler/mailto
xdg-mime default brave-browser.desktop text/calendar

# mime dbs update

sudo update-mime-database -V /usr/share/mime
update-desktop-database -v $XDG_DATA_HOME/applications

