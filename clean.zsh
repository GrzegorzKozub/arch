#!/usr/bin/env zsh

set -e -o verbose

# remove obsolete dirs and files

[[ -d ~/.gnome ]] && rm -rf ~/.gnome
[[ -d ~/.npm ]] && rm -rf ~/.npm
[[ -d ~/.yarn ]] && rm -rf ~/.yarn

[[ -f ~/.yarnrc ]] && rm -f ~/.yarnrc
[[ -f ~/.zshrc ]] && rm -f ~/.zshrc

[[ -d ~/.cache/js-v8flags ]] && rm -rf ~/.cache/js-v8flags
[[ -d ~/.cache/node ]] && rm -rf ~/.cache/node
[[ -d ~/.cache/yarn ]] && rm -rf ~/.cache/yarn

(exit 0)

