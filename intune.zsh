#!/usr/bin/env zsh

set -e -o verbose

# packages

DIR=/tmp/intune
[[ -d $DIR ]] && rm -rf $DIR

git clone git@github.com:GrzegorzKozub/intune.git $DIR

$DIR/install.zsh

rm -rf $DIR

# cleanup

`dirname $0`/packages.zsh

