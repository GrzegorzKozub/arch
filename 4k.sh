#!/bin/sh

fonts() {
  gsettings set org.gnome.desktop.interface text-scaling-factor $1
}

on_term() {
  fonts 1
  trap - SIGTERM
  exit 0
}

trap on_term SIGTERM

fonts 1.5
imwheel -d

