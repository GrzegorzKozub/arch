#!/usr/bin/env zsh

set -o verbose

# worker

if [[ $HOST = 'worker' ]]; then

  for NAME in \
    27gp950-b \
    edid-a22164af5b8f1d511579d86156ddcf41
  do
    ID=$(colormgr find-profile-by-filename $NAME.icm | grep 'Profile ID' | sed -e 's/Profile ID:    //')
    echo "$NAME -> $ID"
    [[ $ID ]] && colormgr delete-profile $ID
    rm -f $XDG_DATA_HOME/icc/$NAME.ic*
  done

  rm -f $XDG_CONFIG_HOME/color.jcnf

  sudo cp $(dirname $0)/etc/udev/rules.d/10-c922.rules /etc/udev/rules.d/10-c922.rules

  cp `dirname $0`/home/$USER/.config/systemd/user/iam.service $XDG_CONFIG_HOME/systemd/user
  systemctl --user enable iam.service

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

