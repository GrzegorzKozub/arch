#!/usr/bin/env zsh

set -e -o verbose

# dev

. `dirname $0`/ansible.zsh
. `dirname $0`/aws.zsh
. `dirname $0`/dotnet.zsh
. `dirname $0`/java.zsh

# apps

. `dirname $0`/postman.zsh
. `dirname $0`/teams.zsh

# hidden links

. `dirname $0`/nodisplay.zsh

# hosts

# . `dirname $0`/hosts.zsh

# dotfiles

. ~/code/dot/work.zsh
