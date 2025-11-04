#!/usr/bin/env zsh

set -o verbose

# uv

sudo pacman -Rs --noconfirm python-pipx

rm -rf $XDG_CACHE_HOME/pip
rm -rf $XDG_CACHE_HOME/pipx
rm -rf $XDG_DATA_HOME/pipx
rm -rf ~/.local/bin
rm -rf ~/.local/state/pipx

rm -rf $XDG_CACHE_HOME/uv
rm -rf $XDG_DATA_HOME/uv

for TOOL in black isort lastversion tidal-dl-ng; do
  uv tool install $TOOL; done

if [[ $HOST =~ ^(drifter|worker)$ ]]; then # work
  for TOOL in awscli-local cfn-lint; do uv tool install $TOOL; done
fi

# reset

# . `dirname $0`/reset.zsh

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

