#!/usr/bin/env bash
set -eo pipefail -ux

# default terminal (xdg-terminal-exec)

for FILE in gnome-xdg-terminals.list xdg-terminals.list; do
  echo 'kitty.desktop' > "$XDG_CONFIG_HOME"/$FILE
done

# default apps

xdg-mime default org.neovim.nvim.desktop application/x-zerosize
xdg-mime default org.neovim.nvim.desktop text/plain

xdg-mime default mpv.desktop audio/mpeg
xdg-mime default mpv.desktop audio/ogg

xdg-mime default mpv.desktop video/mp4
xdg-mime default mpv.desktop video/webm
xdg-mime default mpv.desktop video/x-matroska

xdg-mime default brave-origin.desktop x-scheme-handler/mailto # or brave-borwser.desktop
xdg-mime default brave-origin.desktop text/calendar

# mime dbs update

sudo update-mime-database /usr/share/mime
update-desktop-database "$XDG_DATA_HOME"/applications
