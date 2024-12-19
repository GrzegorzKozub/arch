#!/usr/bin/env zsh

set -o verbose

# vscode

code --uninstall-extension sainnhe.gruvbox-material
code --install-extension grzegorzkozub.gruvbox-material-flat --force

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

