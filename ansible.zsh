#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  ansible-core ansible \
  python-boto3

# config

sudo chfn -f $USER $USER # gecos

# cleanup

. `dirname $0`/packages.zsh

# dotfiles

. ~/code/dot/ansible.zsh

