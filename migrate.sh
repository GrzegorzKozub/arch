#!/usr/bin/env bash
set -eo pipefail -ux

# fswatch

sudo pacman -Rs --noconfirm fswatch
sudo pacman -Sy --noconfirm fswatch

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

# lsp

sudo pacman -Sy --noconfirm lua-language-server

mise install
rustup component add rust-analyzer
uv tool install basedpyright

if [[ $HOST == 'worker' ]]; then

  dotnet tool install --global csharp-ls
  # TODO: jdtls

fi

# mcp

claude mcp remove github || true

# nvidia

[[ $HOST == 'worker' ]] && sudo pacman -S --noconfirm linux-cachyos-lts-nvidia-open

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
