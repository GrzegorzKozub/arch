#!/usr/bin/env zsh

set -e -o verbose

# packages

paru -S --aur --noconfirm \
  postman-bin

# links

if [[ $XDG_SESSION_TYPE = 'wayland' ]]; then

  cp /usr/share/applications/postman.desktop $XDG_DATA_HOME/applications
  sed -i \
    -e 's/\/opt\/postman\/Postman/\/opt\/postman\/Postman --ozone-platform-hint=auto/' \
    $XDG_DATA_HOME/applications/postman.desktop

fi

# cleanup

`dirname $0`/packages.zsh

