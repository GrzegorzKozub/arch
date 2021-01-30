#!/usr/bin/env zsh

set -e -o verbose

# secure boot support

paru -S --aur --noconfirm \
  preloader-signed

