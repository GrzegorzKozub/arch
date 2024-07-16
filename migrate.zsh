#!/usr/bin/env zsh

set -o verbose

# migrate

[[ $HOST = 'worker' ]] && . `dirname $0`/apsis.zsh

sed -i \
  -e 's/export //' \
  -e 's/^/export /' \
  ~/.config/zsh/.zshenv

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

