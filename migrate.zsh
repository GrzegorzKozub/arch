#!/usr/bin/env zsh

set -o verbose

# cleanup

rm -f $XDG_DATA_HOME/applications/electron30.desktop
rm -f $XDG_DATA_HOME/applications/electron31.desktop
rm -f $XDG_DATA_HOME/applications/redshift-gtk.desktop
rm -f $XDG_DATA_HOME/applications/redshift.desktop

rm -f $XDG_DATA_HOME/mimeapps.list

rm -f $SDG_CONFIG_HOME/monitors.xml\~

# shellcheck

paru -S --aur --noconfirm shellcheck-bin

# vscode

for EXTENSION in \
  GitHub.copilot \
  GitHub.copilot-chat
do
  code --install-extension $EXTENSION --force
done

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

