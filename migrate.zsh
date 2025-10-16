#!/usr/bin/env zsh

set -o verbose

# gdm

sudo rm -rf /var/lib/gdm/seat0/config/monitors.xml

# reset

# . `dirname $0`/reset.zsh

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

