#!/usr/bin/env zsh

set -o verbose

# delete docker-machine

[[ $(pacman -Qs docker-machine) ]] &&
  sudo pacman -Rs --noconfirm docker-machine

set +o verbose
declare -A ZINIT
export ZINIT[HOME_DIR]=$XDG_DATA_HOME/zinit
export ZINIT[ZCOMPDUMP_PATH]=$XDG_CACHE_HOME/zsh/zcompdump
source $ZINIT[HOME_DIR]/bin/zinit.zsh
zinit delete --yes OMZ::plugins/docker-machine/_docker-machine
set -o verbose

DIR=$XDG_DATA_HOME/zinit/snippets/OMZ::plugins--docker-machine
[[ -d $DIR ]] && rm -rf $DIR

# add tsx

npm install --global tsx

# manual
# - aws credentials

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

