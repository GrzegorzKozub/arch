#!/usr/bin/env bash
set -eo pipefail -ux

# packages

paru -S --aur --noconfirm \
  postman-bin

# links

cp /usr/share/applications/postman.desktop "$XDG_DATA_HOME"/applications
sed -i \
  -e 's/\/opt\/postman\/Postman/\/opt\/postman\/Postman --ozone-platform-hint=auto/' \
  "$XDG_DATA_HOME"/applications/postman.desktop

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
