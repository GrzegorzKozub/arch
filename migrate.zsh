#!/usr/bin/env zsh

set -o verbose

# migrate

sudo cp `dirname $0`/etc/tmpfiles.d/hibernation_image_size.conf /etc/tmpfiles.d/hibernation_image_size.conf

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

