#!/usr/bin/env bash
set -eo pipefail -ux

# packages

paru -S --aur --noconfirm \
  teams-for-linux-bin

# links

cp /usr/share/applications/teams-for-linux.desktop "$XDG_DATA_HOME"/applications
sed -i \
  -e 's/^Name=.*/Name=Teams/' \
  -e '/^Exec=/s/--ozone-platform=x11/--ozone-platform-hint=auto/' \
  "$XDG_DATA_HOME"/applications/teams-for-linux.desktop

[[ "$XDG_CURRENT_DESKTOP" == 'GNOME' ]] && {
  FAVS=$(gsettings get org.gnome.shell favorite-apps)
  [[ $(echo "$FAVS" | grep 'teams-for-linux.desktop') ]] || {
    FAVS=$(echo "$FAVS" | sed "s/'brave-browser.desktop'/'brave-browser.desktop', 'teams-for-linux.desktop'/")
    gsettings set org.gnome.shell favorite-apps "$FAVS"
  }
}

# cleanup

"${BASH_SOURCE%/*}"/packages.sh

# dotfiles

~/code/dot/teams.sh
