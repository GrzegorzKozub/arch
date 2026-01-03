#!/usr/bin/env zsh

set -e -o verbose

# packages

paru -S --aur --noconfirm \
  teams-for-linux

# links

cp /usr/share/applications/teams-for-linux.desktop $XDG_DATA_HOME/applications
sed -i \
  -e 's/^Name=.*/Name=Teams/' \
  -e '/^Exec=/s/--gtk-version=3//' \
  -e '/^Exec=/s/teams-for-linux/teams-for-linux --ozone-platform-hint=auto/' \
  $XDG_DATA_HOME/applications/teams-for-linux.desktop

[[ $XDG_CURRENT_DESKTOP = 'GNOME' ]] && {
  FAVS=$(gsettings get org.gnome.shell favorite-apps)
  [[ $(echo $FAVS | grep 'teams-for-linux.desktop') ]] || {
    FAVS=$(echo $FAVS | sed "s/'brave-browser.desktop'/'brave-browser.desktop', 'teams-for-linux.desktop'/")
    gsettings set org.gnome.shell favorite-apps $FAVS
  }
}

# cleanup

`dirname $0`/packages.zsh

# dotfiles

~/code/dot/teams.zsh

