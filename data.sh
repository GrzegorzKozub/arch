#!/usr/bin/env bash
set -eo pipefail -ux

create() {
  local dir=/run/media/"$USER"/data/"$1"
  [[ -d $dir ]] && return
  sudo mkdir "$dir"
  sudo chown "$USER" "$dir"
  sudo chgrp users "$dir"
}

create ".Trash-$(id -u)"

create '.cache'
create '.data'
create '.secrets'

create 'music'
create 'vm'
