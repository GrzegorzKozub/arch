#!/usr/bin/env zsh

set -o verbose

# cleanup

rm -f ~/.local/share/mimeapps.list
rm -f ~/.config/monitors.xml\~

# shellcheck

paru -S --aur --noconfirm shellcheck-bin

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

