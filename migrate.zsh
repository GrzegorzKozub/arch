#!/usr/bin/env zsh

set -o verbose

# bat

bat cache --build

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

