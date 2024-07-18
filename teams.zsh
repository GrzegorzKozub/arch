#!/usr/bin/env zsh

set -e -o verbose

# packages

paru -S --aur --noconfirm \
  teams-for-linux

# links

cp /usr/share/applications/teams-for-linux.desktop $XDG_DATA_HOME/applications
sed -i -e 's/^Name=.*/Name=Teams/' $XDG_DATA_HOME/applications/teams-for-linux.desktop

if [[ $XDG_SESSION_TYPE = 'wayland' ]]; then

  sed -i \
    -e 's/^Exec=teams-for-linux/Exec=teams-for-linux --disable-features=WaylandFractionalScaleV1 --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto/' \
    $XDG_DATA_HOME/applications/teams-for-linux.desktop

fi

[[ $XDG_CURRENT_DESKTOP = 'GNOME' ]] && {
  FAVS=$(gsettings get org.gnome.shell favorite-apps)
  [[ $(echo $FAVS | grep 'teams-for-linux.desktop') ]] || {
    FAVS=$(echo $FAVS | sed "s/\]/, 'teams-for-linux.desktop']/")
    gsettings set org.gnome.shell favorite-apps $FAVS
  }
}

# cleanup

sudo pacman -Rs --noconfirm \
  node-gyp nodejs npm

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

# dotfiles

. ~/code/dotfiles/teams.zsh

