#!/usr/bin/env bash
set -eo pipefail -ux

# packages

DIR=/tmp/intune
[[ -d $DIR ]] && rm -rf $DIR

git clone git@github.com:GrzegorzKozub/intune.git $DIR

$DIR/install.sh

rm -rf $DIR

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
