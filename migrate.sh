#!/usr/bin/env bash
set -eo pipefail -ux

# lsp

sudo pacman -S --noconfirm lua-language-server

# hosts

if [[ $HOST == 'worker' ]]; then

  LIST=(
    8favxfpaq6.execute-api.eu-west-1.amazonaws.com
    ANUNLB-LB-VC5YGOQNTGG4-7707d28b7ca45024.elb.eu-west-1.amazonaws.com
    WAWNLB2-LB-2KEW9GHX6ZHK-3cd7f3576423cce8.elb.eu-west-1.amazonaws.com
    WAWNLB2-LB-BFAMMO58AJC7-ac1f28233c0b6fc5.elb.eu-west-1.amazonaws.com
    api.stage.ma
    audienceproxy.ecs-stage.webscript
    capturetool.ecs-stage.webscript
    formtoolbackend.ecs-stage.webscript
    int.email-stage.apsis.cloud
    int.folders-stage.apsis.cloud
    vpce-0d42f60518b6200ca-t05wvrwd.vpce-svc-0e2cc8023f4c8b06f.eu-west-1.vpce.amazonaws.com
  )

  for ITEM in "${LIST[@]}"; do
    sudo sed -i -e "/.*$ITEM.*/d" /etc/hosts
  done

fi

# brightness

if [[ $HOST == 'drifter' ]]; then

  sudo systemctl disable brightness.service
  sudo rm -f /etc/systemd/system/brightness.service

  systemctl --user disable brightness.service
  rm -f "$XDG_CONFIG_HOME"/systemd/user/brightness.service

fi

# gnome

dconf reset -f /org/gnome/Characters/
sudo pacman -Rs --noconfirm gnome-characters gnome-font-viewer || true

# services

systemctl --user disable dnd.service wall.timer

cp "${BASH_SOURCE%/*}"/home/.config/systemd/user/dnd.service "$XDG_CONFIG_HOME"/systemd/user
cp "${BASH_SOURCE%/*}"/home/.config/systemd/user/wall.timer "$XDG_CONFIG_HOME"/systemd/user

systemctl --user enable dnd.service wall.timer

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
