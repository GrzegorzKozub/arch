#!/usr/bin/env zsh

set -o verbose

# migrate

[[ $HOST = 'player' ]] && sudo pacman -S libva-nvidia-driver

[[ $HOST = 'worker' ]] && . `dirname $0`/apsis.zsh

sed -i \
  -e 's/export //' \
  -e 's/^/export /' \
  ~/.config/zsh/.zshenv

rm $XDG_CONFIG_HOME/environment.d

rm -rf $XDG_CONFIG_HOME/btop

pushd ~/code/dotfiles

git update-index --no-assume-unchanged btop/btop.conf
git reset --hard
git pull
git update-index --assume-unchanged btop/btop/btop.conf

popd



# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

