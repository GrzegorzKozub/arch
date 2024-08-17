#!/usr/bin/env zsh

set -o verbose

# migrate

sudo pacman -S --noconfirm \
  fwupd

set +e
sudo pacman -Rs --noconfirm \
  ouch
set -e

FILE=$XDG_CONFIG_HOME/yazi/package.toml
[[ -f $FILE ]] && rm -f $FILE

for PLUGIN in \
  KKV9/compress \
  yazi-rs/plugins#jump-to-char
do
  ya pack --add "$PLUGIN"
done

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

