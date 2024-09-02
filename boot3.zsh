#!/usr/bin/env zsh

set -e -o verbose

# secure boot support using PreLoader

paru -S --aur --noconfirm \
  preloader-signed

