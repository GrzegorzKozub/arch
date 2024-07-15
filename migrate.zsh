#!/usr/bin/env zsh

set -o verbose

# migrate

rm ~/.config/monitors.xml~

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

