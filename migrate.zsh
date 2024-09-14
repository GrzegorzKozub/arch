#!/usr/bin/env zsh

set -o verbose

# nvim

rm -rf ~/.cache/nvim

# yazi

sudo pacman -Rs --noconfirm \
  ffmpegthumbnailer

FILE=$XDG_CONFIG_HOME/yazi/package.toml
[[ -f $FILE ]] && rm -f $FILE

for PLUGIN in \
  KKV9/compress \
  Tyarel8/video-ffmpeg \
  yazi-rs/plugins:git \
  yazi-rs/plugins:jump-to-char
do
  ya pack --add "$PLUGIN"
done

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

