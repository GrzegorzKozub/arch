#!/usr/bin/env zsh

set -e -o verbose

DIR=$XDG_DATA_HOME/gnome-shell/extensions
cp -r `dirname $0`/home/$USER/.local/share/gnome-shell/extensions/windows@grzegorzkozub.github.com $DIR
pushd $DIR/windows@grzegorzkozub.github.com && glib-compile-schemas schemas && popd
