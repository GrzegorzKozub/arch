#!/usr/bin/env bash
set -eo pipefail -ux

# tiddl

pushd ~/code/dot
./reset.sh python
./links.sh
popd

rm -rf ~/.config/tidal_dl_ng-dev

sed -i 's/facebookUid: int$/facebookUid: Optional[int] = None/' \
  "$XDG_DATA_HOME"/uv/tools/tiddl/lib/python3.14/site-packages/tiddl/core/auth/models.py

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
