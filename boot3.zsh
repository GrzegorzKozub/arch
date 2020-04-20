#!/usr/bin/env zsh

set -e -o verbose

# secure boot support

yay -S --aur --noconfirm \
  preloader-signed

