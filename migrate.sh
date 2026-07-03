#!/usr/bin/env bash
set -eo pipefail -ux

# dot
# ansible, cava, git, maven, nushell, obsidian, silicon, teams-for-linux, tidal-hifi, vscode, yazi, nvim

# airplane mode

rfkill unblock all
"${BASH_SOURCE%/*}"/settings.sh

# gnome

sudo pacman -Rs --noconfirm gnome-system-monitor || true

dconf reset -f /org/gnome/eog/
dconf reset -f /org/gnome/evince/
dconf reset -f /org/gnome/gnome-system-monitor/
dconf reset -f /org/gnome/shell/extensions/rounded-window-corners/

rm -f "$XDG_DATA_HOME"/applications/org.gnome.tweaks.desktop

# locale

sudo locale-gen

# nushell

sudo pacman -Rs --noconfirm nushell || true
rm -rf ~/.config/nushell

# pacman -> yay

pushd ~/code/dot
git pull && git submodule foreach --recursive git pull
./links.sh
popd

"${BASH_SOURCE%/*}"/yay.sh

yay --aur --noconfirm -Rs paru || true
rm -rf ~/.cache/paru
rm -rf ~/.local/state/paru

yay --aur --noconfirm --answerdiff=None -S tmux-git

# systemd

sudo mkdir -p /etc/systemd/user.conf.d
sudo cp "${BASH_SOURCE%/*}"/etc/systemd/user.conf.d/00-timeout.conf /etc/systemd/user.conf.d

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
