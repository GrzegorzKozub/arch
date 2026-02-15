#!/usr/bin/env bash
set -eo pipefail -ux

# packages

sudo pacman -S --noconfirm \
  obs-studio

  # linux-headers v4l2loopback-dkms

# links

cp /usr/share/applications/com.obsproject.Studio.desktop "$XDG_DATA_HOME"/applications
sed -i \
  -e 's/^Exec=/Exec=env QT_QPA_PLATFORM=wayland /' \
  "$XDG_DATA_HOME"/applications/com.obsproject.Studio.desktop

# cleanup

"${BASH_SOURCE%/*}"/packages.sh

# dotfiles

~/code/dot/obs.sh
