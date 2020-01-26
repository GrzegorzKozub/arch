#!/usr/bin/zsh

set -e -o verbose

# dotfiles

if [ -d ~/dotfiles ]; then rm -rf ~/dotfiles; fi

pushd ~
git clone --recursive git@github.com:GrzegorzKozub/dotfiles.git ~/dotfiles
cd ~/dotfiles
git submodule update --init
git submodule foreach --recursive git checkout master
popd

cp -rf ~/dotfiles/*(DN) ~/
rm -rf ~/dotfiles

