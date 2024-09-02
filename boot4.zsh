#!/usr/bin/env zsh

set -e -o verbose

# secure boot support using PreLoader

paru -Rs --aur --noconfirm \
  preloader-signed

