#!/usr/bin/env zsh

set -o verbose

# migrate

sudo pacman -S --noconfirm \
  realtime-privileges

sudo usermod -a -G realtime greg

sudo cp `dirname $0`/etc/tmpfiles.d/rtc.conf /etc/tmpfiles.d

if [[ $MY_HOSTNAME = 'player' ]]; then

  sudo rm /etc/modprobe.d/nvidia-power-management.conf
  echo 'options nvidia NVreg_PreserveVideoMemoryAllocations=1 NVreg_TemporaryFilePath=/var/tmp' | sudo tee /etc/modprobe.d/nvidia.conf > /dev/null

fi

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

