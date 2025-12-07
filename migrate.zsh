#!/usr/bin/env zsh

set -o verbose

# fetch

rm -f $XDG_CACHE_HOME/zsh/zcompdump

# mkinitcpio

sudo sed -i 's/^ALL_microcode/#ALL_microcode/' /etc/mkinitcpio.d/linux-lts.preset

# yt-dlp

sudo pacman -Rs --noconfirm python-secretstorage yt-dlp
uv tool install --with yt-dlp-ejs 'yt-dlp[secretstorage]'

# reset

# . `dirname $0`/reset.zsh

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

