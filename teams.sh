#!/usr/bin/env bash
set -eo pipefail -ux

# packages

yay --aur --noconfirm --answerdiff=None -S \
  teams-for-linux-bin

# links

[[ "$XDG_CURRENT_DESKTOP" == 'GNOME' ]] && {
  FAVS=$(gsettings get org.gnome.shell favorite-apps)
  echo "$FAVS" | grep -q 'teams-for-linux.desktop' || {
    FAVS=${FAVS/"'brave-origin.desktop'"/"'brave-origin.desktop', 'teams-for-linux.desktop'"}
    gsettings set org.gnome.shell favorite-apps "$FAVS"
  }
}
  # or brave-browser.desktop

# cleanup

"${BASH_SOURCE%/*}"/packages.sh

# dotfiles

~/code/dot/teams.sh
