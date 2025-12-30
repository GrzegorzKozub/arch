#!/usr/bin/env zsh

set -o verbose

# shutdown bug: https://bbs.archlinux.org/viewtopic.php?pid=2278862

# fetch

sudo pacman -S --noconfirm python-requests

# secrets

pushd ~/code/dot
git update-index --no-assume-unchanged maven/maven/settings.xml
popd

if [[ $HOST = 'player' ]]; then

  rm -rf ~/.config/aws
  pushd ~/code/keys
  git update-index --no-assume-unchanged aws/aws/credentials
  popd

fi

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

