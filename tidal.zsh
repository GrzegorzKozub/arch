#!/usr/bin/env zsh

set -e -o verbose

# packages

paru -S --aur --noconfirm \
  tidal-hifi-bin

# links

cp /usr/share/applications/tidal-hifi.desktop $XDG_DATA_HOME/applications
sed -i \
  -e 's/^Name=.*/Name=TIDAL/' \
  $XDG_DATA_HOME/applications/tidal-hifi.desktop

# dash

[[ $XDG_CURRENT_DESKTOP = 'GNOME' ]] && {
  FAVS=$(gsettings get org.gnome.shell favorite-apps)
  [[ $(echo $FAVS | grep 'tidal-hifi.desktop') ]] || {
    FAVS=$(
      echo $FAVS |
      sed -e "s/'brave-browser.desktop'/'brave-browser.desktop', 'tidal-hifi.desktop'/"
    )
    gsettings set org.gnome.shell favorite-apps $FAVS
  }
}

# dotfiles

. ~/code/dot/tidal.zsh

