#!/usr/bin/env bash
set -eo pipefail -ux

# claude code sandbox bug: https://github.com/anthropics/claude-code/issues/17087
# shutdown bug: https://bbs.archlinux.org/viewtopic.php?pid=2278862

# jack

set +e
yes | sudo pacman -S pipewire-jack
set -e

# wireplumber

if [[ -f "${BASH_SOURCE%/*}"/home/$USER/.config/wireplumber/wireplumber.conf.d/$HOST.conf ]]; then

  [[ -d $XDG_CONFIG_HOME/wireplumber/wireplumber.conf.d ]] || mkdir -p "$XDG_CONFIG_HOME"/wireplumber/wireplumber.conf.d
  cp "${BASH_SOURCE%/*}"/home/"$USER"/.config/wireplumber/wireplumber.conf.d/"$HOST".conf "$XDG_CONFIG_HOME"/wireplumber/wireplumber.conf.d/audio.conf

  systemctl --user restart wireplumber

fi

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
