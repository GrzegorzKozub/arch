#!/usr/bin/env zsh

set -o verbose

# audio

[[ -d $XDG_CONFIG_HOME/pipewire/pipewire.conf.d ]] || mkdir -p $XDG_CONFIG_HOME/pipewire/pipewire.conf.d
cp `dirname $0`/home/$USER/.config/pipewire/pipewire.conf.d/10-clock-rate.conf $XDG_CONFIG_HOME/pipewire/pipewire.conf.d

if [[ -f `dirname $0`/home/$USER/.config/wireplumber/wireplumber.conf.d/$HOST.conf ]]; then

  [[ -d $XDG_CONFIG_HOME/wireplumber/wireplumber.conf.d ]] || mkdir -p $XDG_CONFIG_HOME/wireplumber/wireplumber.conf.d
  cp `dirname $0`/home/$USER/.config/wireplumber/wireplumber.conf.d/$HOST.conf $XDG_CONFIG_HOME/wireplumber/wireplumber.conf.d/audio.conf

fi

# amberol

sudo pacman -S --noconfirm amberol

# python

rm -rf $XDG_CONFIG_HOME/ipython

rm -rf $XDG_CACHE_HOME/pip
rm -rf $XDG_CACHE_HOME/pipx

rm -rf ~/.local/bin
rm -rf ~/.local/include
rm -rf ~/.local/lib

sudo pacman -S --noconfirm python-pipx python-pynvim

pipx install --force \
  awscli-local \
  cfn-lint \
  lastversion \
  tidal-dl-ng

# nvim

# rm -rf $XDG_CACHE_HOME/nvim
# rm -rf $XDG_DATA_HOME/nvim
# rm -rf ~/.local/state/nvim
# nvim \
#   -c 'autocmd User MasonToolsUpdateCompleted quitall' \
#   -c 'autocmd User VeryLazy MasonToolsUpdate'

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

