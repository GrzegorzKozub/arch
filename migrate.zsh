#!/usr/bin/env zsh

set -o verbose

# shutdown bug: https://bbs.archlinux.org/viewtopic.php?pid=2278862

# secrets

if [[ $HOST = 'player' ]]; then

  rm -rf ~/.config/aws
  pushd ~/code/keys
  git update-index --assume-unchanged aws/aws/credentials
  popd

fi

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

