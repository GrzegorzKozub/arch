#!/usr/bin/zsh

set -e -o verbose

# dirs

if [ ! -d ~/code ]; then mkdir ~/code; fi

# dotfiles

if [ -d ~/code/dotfiles ]; then rm -rf ~/code/dotfiles; fi
git clone --recursive git@github.com:GrzegorzKozub/dotfiles.git ~/code/dotfiles

pushd ~
cd ~/code/dotfiles
git submodule update --init
git submodule foreach --recursive git checkout master
popd

cp -rf ~/code/dotfiles/*(DN) ~/

