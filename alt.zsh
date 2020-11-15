#!/usr/bin/env zsh

# https://gitlab.gnome.org/GNOME/gnome-control-center/-/issues/1180

gsettings set org.gnome.desktop.input-sources xkb-options "['lv3:ralt_switch']"
gsettings set org.gnome.desktop.input-sources xkb-options "[]"

