#!/usr/bin/env bash
set -eo pipefail -ux

# pacman

sudo pacman -Sy

# dot

pushd ~/code/dot
git update-index --no-assume-unchanged tidal-hifi/tidal-hifi/config.json
git reset --hard
git pull
./repos.sh
./links.sh
popd

# zi

rm -rf "$XDG_CACHE_HOME"/{f-sy-h,fsh,p10k*,zsh,zi,zinit}
rm -rf "$XDG_CONFIG_HOME"/{fsh,zi}
rm -rf "$XDG_DATA_HOME"/zi

  # manual step: rm -rf "$XDG_DATA_HOME"/zinit

mkdir -p "$XDG_CACHE_HOME"/zsh
mkdir -p "$XDG_DATA_HOME"/zi

git clone https://github.com/z-shell/zi.git "$XDG_DATA_HOME"/zi/bin

script -c "env ZI_BOOTSTRAP=1 zsh -i" /dev/null

# fonts

[[ $HOST == 'player' ]] &&
  sudo pacman -S --noconfirm noto-fonts-emoji &&
  fc-cache -f

# fsmonitor

if [[ $HOST =~ ^(player|worker)$ ]]; then
  for DIR in ~/code/*/ ~/code/*/*/; do
    [[ -d $DIR/.git ]] || continue
    rm -rf "$DIR"/.git/fsmonitor--daemon "$DIR"/.git/fsmonitor--daemon.ipc
  done
fi

# llama-cpp

[[ $HOST =~ ^(player|worker)$ ]] &&
  sudo pacman -Rs --noconfirm llama-cpp-vulkan-bin || true

# mise: claude & go

rm -rf "$XDG_CACHE_HOME"/{go,goimports,gopls}
rm -rf "$XDG_CONFIG_HOME"/go
go clean -modcache && rm -rf "$XDG_DATA_HOME"/go

sudo pacman -Rs --noconfirm go || true
sudo pacman -S --noconfirm mise

mise install

if [[ $HOST == 'worker' ]]; then

  for DIR in \
    ~/.claude \
    ~/.cache/claude \
    ~/.cache/claude-cli-nodejs \
    ~/.local/bin/claude \
    ~/.local/share/claude \
    ~/.local/state/claude; do
    rm -rf "$DIR"
  done

  "${BASH_SOURCE%/*}"/claude.sh

fi

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
