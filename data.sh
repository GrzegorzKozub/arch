#!/usr/bin/env bash

set -e -o verbose

create() {
  local dir=/run/media/"$USER"/data/"$1"
  [[ -d $dir ]] && return
  sudo mkdir "$dir"
  sudo chown "$USER" "$dir"
  sudo chgrp users "$dir"
}

create '.cache'
create '.data'
create '.secrets'
create 'music'
create 'vm'
