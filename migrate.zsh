#!/usr/bin/env zsh

set -o verbose

# yazi

FILE=$XDG_CONFIG_HOME/yazi/package.toml
[[ -f $FILE ]] && rm -f $FILE

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

