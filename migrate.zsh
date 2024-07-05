#!/usr/bin/env zsh

set -o verbose

# migrate

if [[ $HOST = 'player' ]]; then

  echo 'options nvidia NVreg_PreserveVideoMemoryAllocations=1 NVreg_TemporaryFilePath=/var/tmp' |
    sudo tee /etc/modprobe.d/nvidia-power-management.conf > /dev/null

  sudo systemctl enable nvidia-hibernate.service
  sudo systemctl enable nvidia-resume.service
  sudo systemctl enable nvidia-suspend.service

  sudo systemctl unmask colord.service

  systemctl --user disable colors.service

  rm $XDG_CONFIG_HOME/systemd/user/colors.service

  systemctl --user stop redshift.service
  systemctl --user disable redshift.service

  rm $XDG_CONFIG_HOME/systemd/user/redshift.service

  rm -rf $XDG_CONFIG_HOME/redshift
  rm $XDG_DATA_HOME/applications/redshift*

  sudo pacman -Rs redshift

  gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
  gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic true

  dispwin -d1 -U

  rm -rf $XDG_CONFIG_HOME/color

fi

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

