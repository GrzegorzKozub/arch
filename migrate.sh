#!/usr/bin/env bash
set -eo pipefail -ux

# brave
# manual: cache, config, apsis|greg-linux-drifter|player|worker

rm -rf ~/.config/chromium
rm -rf ~/.config/google-chrome

rm -rf "$XDG_CONFIG_HOME"/brave-flags.conf
pushd ~/code/dot && ./links.sh && popd

sudo pacman -Rs --noconfirm brave-bin

dconf reset -f /org/gnome/settings-daemon/global-shortcuts/brave-browser/
dconf reset -f /org/gnome/settings-daemon/global-shortcuts/org.chromium.Chromium/
dconf reset /org/gnome/settings-daemon/global-shortcuts/applications

paru -S --aur --noconfirm brave-origin-bin

# playerctl

sudo pacman -S --noconfirm playerctl

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
