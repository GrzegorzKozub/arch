#!/usr/bin/env zsh

set -o verbose

# bash

rm -f ~/.bash_history
rm -f ~/.bash_logout
rm -f ~/.bash_profile
rm -f ~/.bashrc

# electron

rm -rf ~/.cache/electron

# gnome

rm -rf ~/.gnome

# node

rm -f ~/.yarnrc

rm -rf ~/.npm
rm -rf ~/.yarn

rm -rf ~/.cache/js-v8flags
rm -rf ~/.cache/node
rm -rf ~/.cache/node-gyp
rm -rf ~/.cache/yarn

# nvidia

rm -f ~/.nvidia-settings-rc

rm -rf ~/.nv

# vim

rm -f ~/.viminfo

# zsh

rm -f ~/.zshrc

(exit 0)

