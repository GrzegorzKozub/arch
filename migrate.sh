#!/usr/bin/env bash
set -eo pipefail -ux

# tiddl

pushd ~/code/dot
./reset.sh python
./links.sh
popd

rm -rf ~/.config/tidal_dl_ng-dev

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
