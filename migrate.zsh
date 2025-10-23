#!/usr/bin/env zsh

set -o verbose

# rclone

pushd ~/code/dot
git update-index --no-assume-unchanged rclone/rclone/rclone.conf
popd

# tree-sitter

sudo pacman -Rs --noconfirm tree-sitter
sudo pacman -S --noconfirm tree-sitter-cli

# vscode

[[ $HOST =~ ^(drifter|worker)$ ]] && code --install-extension redhat.java --force

# uv

sudo pacman -S --noconfirm uv

# weather

sudo pacman -S --noconfirm gnome-weather

# reset

# . `dirname $0`/reset.zsh

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

