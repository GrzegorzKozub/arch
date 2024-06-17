#!/usr/bin/env zsh

set -e -o verbose

# remove obsolete dirs and files

rm -rf ~/.bash*

[[ -d ~/.gnome ]] && rm -rf ~/.gnome

[[ -f ~/.zshrc ]] && rm -f ~/.zshrc

[[ -d ~/.cache/node ]] && rm -rf ~/.cache/node
[[ -d ~/.npm ]] && rm -rf ~/.npm

[[ -d ~/.cache/yarn ]] && rm -rf ~/.cache/yarn
[[ -d ~/.yarn ]] && rm -rf ~/.yarn
[[ -f ~/.yarnrc ]] && rm -f ~/.yarnrc

[[ -d ~/.cache/js-v8flags ]] && rm -rf ~/.cache/js-v8flags

(exit 0)

