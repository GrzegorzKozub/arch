#!/usr/bin/env zsh

set -o verbose

# paru

[[ -d ~/paru ]] && rm -rf ~/paru

pushd ~

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm

popd

rm -rf ~/paru
rm -rf ~/.cargo

sudo pacman -Rs --noconfirm \
  rust

# apps

sudo pacman -S --noconfirm \
  go-yq \
  silicon \
  zoxide

paru -S --aur --noconfirm \
  ttf-victor-mono

# fetch

cp `dirname $0`/home/$USER/.config/systemd/user/fetch.service $XDG_CONFIG_HOME/systemd/user
systemctl --user enable fetch.service

