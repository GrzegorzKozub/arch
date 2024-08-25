#!/usr/bin/env zsh

set -o verbose

# shell

rm -f ~/.bash_history
rm -f ~/.zshrc

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

# electron

rm -rf ~/.cache/electron

(exit 0)

