#!/usr/bin/env zsh

set -e -o verbose

# dev

if [[ $HOST == 'worker' ]]; then

  `dirname $0`/ansible.zsh
  `dirname $0`/aws.zsh
  `dirname $0`/claude.sh
  `dirname $0`/dotnet.sh
  `dirname $0`/java.zsh

fi

# apps

[[ $HOST == 'worker' ]] && `dirname $0`/postman.zsh
[[ $HOST =~ ^(drifter|worker)$ ]] && `dirname $0`/teams.sh

# hidden links

`dirname $0`/nodisplay.zsh

# hosts

[[ $HOST == 'worker' ]] && `dirname $0`/hosts.zsh

# dotfiles

[[ $HOST == 'worker' ]] &&  ~/code/dot/work.zsh
