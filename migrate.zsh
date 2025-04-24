#!/usr/bin/env zsh

set -o verbose

# first update arch & dotfiles

# dotfiles -> dot

[[ -d ~/code/dotfiles ]] && mv ~/code/dotfiles ~/code/dot

pushd ~/code/dot
git remote set-url origin git@github.com:GrzegorzKozub/dot.git
popd

. ~/dot/migrate.zsh

# passwords -> pass

[[ -d ~/code/passwords ]] && mv ~/code/passwords ~/code/pass

pushd ~/code/pass
git remote set-url origin git@github.com:GrzegorzKozub/pass.git
popd

sed -i -e 's/passwords/pass/g' $XDG_CACHE_HOME/keepassxc/keepassxc.ini

# ghostty

sudo pacman -S --noconfirm ghostty

# nvim

rm -rf $XDG_CACHE_HOME/nvim
rm -rf $XDG_DATA_HOME/nvim
rm -rf ~/.local/state/nvim

nvim \
  -c 'autocmd User MasonToolsUpdateCompleted quitall' \
  -c 'autocmd User VeryLazy MasonToolsUpdate'

# vconsole

[[ $HOST = 'player' ]] &&
  sudo sed -i -e 's/216b/232b/' /etc/vconsole.conf

# vscode

code --uninstall-extension docker.docker

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

