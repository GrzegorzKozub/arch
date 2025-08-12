#!/usr/bin/env zsh

set -o verbose

if [[ $HOST = 'drifter' ]]; then

  # audio

  [[ -d $XDG_CONFIG_HOME/pipewire/pipewire.conf.d ]] || mkdir -p $XDG_CONFIG_HOME/pipewire/pipewire.conf.d
  cp `dirname $0`/home/$USER/.config/pipewire/pipewire.conf.d/10-clock-rate.conf $XDG_CONFIG_HOME/pipewire/pipewire.conf.d

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

fi

if [[ $HOST = 'worker' ]]; then

  for NAME in \
    27ud88-w \
    edid-08216f324b06ea25324336574c6b0cde \
    edid-84f5a9e5168167d361361f27b7fdbf8a \
    edid-a22164af5b8f1d511579d86156ddcf41
  do
    ID=$(colormgr find-profile-by-filename $NAME.icm | grep 'Profile ID' | sed -e 's/Profile ID:    //')
    echo "$NAME -> $ID"
    [[ $ID ]] && colormgr delete-profile $ID
    rm -f $XDG_DATA_HOME/icc/$NAME.ic*
  done

fi

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

