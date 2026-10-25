#!/usr/bin/env bash
set -eo pipefail -ux

# prep

pushd "${BASH_SOURCE%/*}" && git pull && popd
pushd ~/code/dot && git pull && ./repos.sh && popd
sudo pacman -Sy

# keepassxc

rm -rf "$XDG_DATA_HOME"/applications/org.keepassxc.KeePassXC.desktop

# mise

sudo pacman --noconfirm -Rs prettier || true

if [[ $HOST == 'worker' ]]; then

  sudo pacman --noconfirm -Rs aws-cli-v2 || true
  yay --aur --noconfirm -Rs aws-sam-cli-bin || true

  rm -rf "$XDG_CACHE_HOME"/yay/aws-sam-cli-bin

  ln -sf "$XDG_CONFIG_HOME"/mise/conf.d/aws.env.toml \
    "$XDG_CONFIG_HOME"/mise/conf.d/aws."$HOST".local.toml

fi

~/code/dot/reset.sh mise

# services

sudo cp "${BASH_SOURCE%/*}"/etc/systemd/user.conf.d/00-timeout.conf /etc/systemd/user.conf.d

cp "${BASH_SOURCE%/*}"/home/.config/systemd/user/snap.{service,timer} "$XDG_CONFIG_HOME"/systemd/user
cp "${BASH_SOURCE%/*}"/home/.config/systemd/user/sync.{service,timer} "$XDG_CONFIG_HOME"/systemd/user
cp "${BASH_SOURCE%/*}"/home/.config/systemd/user/wall.{service,timer} "$XDG_CONFIG_HOME"/systemd/user

systemctl --user disable --now sync-periodic.timer || true
rm -f "$XDG_CONFIG_HOME"/systemd/user/sync-periodic.{service,timer}

systemctl --user enable --now sync.timer

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
