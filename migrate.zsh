#!/usr/bin/env zsh

set -o verbose

# migrate

paru -S --aur --noconfirm \
  gnome-shell-extension-rounded-window-corners-reborn

rm -rf ~/.cache/npm

fnm uninstall 22
fnm install --latest
fnm use default

npm install --global \
  autocannon \
  eslint \
  neovim \
  typescript

paru -S --aur --noconfirm \
  teams-for-linux

cp /usr/share/applications/teams-for-linux.desktop $XDG_DATA_HOME/applications
sed -i -e 's/^Name=.*/Name=Teams/' $XDG_DATA_HOME/applications/teams-for-linux.desktop

if [[ $XDG_SESSION_TYPE = 'wayland' ]]; then

  sed -i \
    -e 's/^Exec=teams-for-linux/Exec=teams-for-linux --disable-features=WaylandFractionalScaleV1 --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto/' \
    $XDG_DATA_HOME/applications/teams-for-linux.desktop

fi

sudo pacman -Rs --noconfirm \
  node-gyp nodejs npm

pushd ~/code/dotfiles

stow --dir=`dirname $0` --target=$XDG_CONFIG_HOME --stow \
  teams-for-linux

popd

paru -S --aur --noconfirm \
  vivify-bin

# migrate next

sudo pacman -S --noconfirm \
  realtime-privileges

sudo usermod -a -G realtime greg

sudo cp `dirname $0`/etc/tmpfiles.d/rtc.conf /etc/tmpfiles.d

if [[ $MY_HOSTNAME = 'player' ]]; then

  sudo rm /etc/modprobe.d/nvidia-power-management.conf
  echo 'options nvidia NVreg_UsePageAttributeTable=1 NVreg_PreserveVideoMemoryAllocations=1 NVreg_TemporaryFilePath=/var/tmp' | sudo tee /etc/modprobe.d/nvidia.conf > /dev/null

fi

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

