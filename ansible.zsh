#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  ansible-core ansible \
  python-boto3

# settings

sudo chfn -f greg greg # gecos

# cleanup

. `dirname $0`/packages.zsh

# dotfiles

. ~/code/dot/ansible.zsh

