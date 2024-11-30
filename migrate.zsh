#!/usr/bin/env zsh

set -o verbose

# bat

bat cache --build

# yazi

rm -f ~/.config/yazi/package.toml
rm -rf ~/.config/yazi/plugins/video-ffmpeg
rm -rf ~/.local/state/yazi

for PLUGIN in \
  GrzegorzKozub/mdcat \
  KKV9/compress \
  yazi-rs/plugins:git \
  yazi-rs/plugins:jump-to-char
do
  ya pack --add "$PLUGIN"
done

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

