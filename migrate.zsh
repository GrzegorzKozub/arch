#!/usr/bin/env zsh

set -o verbose

# migrate

if [[ $HOST = 'player' ]]; then

  echo 'options nvidia NVreg_PreserveVideoMemoryAllocations=1 NVreg_TemporaryFilePath=/var/tmp' |
    sudo tee /etc/modprobe.d/nvidia-power-management.conf > /dev/null

  sudo systemctl enable nvidia-hibernate.service
  sudo systemctl enable nvidia-resume.service
  sudo systemctl enable nvidia-suspend.service

fi

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

