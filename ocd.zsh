#!/usr/bin/env zsh

set -e -o verbose

[[ -d ~/.local/share/gnome-shell/extensions ]] || mkdir -p ~/.local/share/gnome-shell/extensions

cp -r \
  `dirname $0`/home/greg/.local/share/gnome-shell/extensions/ocd@example.com \
  ~/.local/share/gnome-shell/extensions

pushd ~/.local/share/gnome-shell/extensions/ocd@example.com
glib-compile-schemas schemas
popd

