#!/usr/bin/env zsh

set -o verbose

# 7z

paru -Rs --aur --noconfirm 7-zip-full
sudo pacman -S --noconfirm 7zip

# bat

bat cache --build

pushd $XDG_CONFIG_HOME/silicon
silicon --build-cache
popd

# mdcat

sudo pacman -Rs --noconfirm mdcat

# yazi

rm -f ~/.config/yazi/package.toml
rm -rf ~/.config/yazi/plugins/compress.yazi
rm -rf ~/.config/yazi/plugins/git.yazi
rm -rf ~/.config/yazi/plugins/jump-to-char.yazi
rm -rf ~/.config/yazi/plugins/mdcat.yazi
rm -rf ~/.config/yazi/plugins/video-ffmpeg.yazi
rm -rf ~/.local/state/yazi

for PLUGIN in \
  KKV9/compress \
  yazi-rs/plugins:git \
  yazi-rs/plugins:jump-to-char
do
  ya pack --add "$PLUGIN"
done

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

