#!/usr/bin/env bash
set -eo pipefail -ux

# docx2txt

sudo pacman -S --noconfirm docx2txt

# github

"${BASH_SOURCE%/*}"/data.sh
"${BASH_SOURCE%/*}"/secrets.sh

# worktrunk

sudo pacman -S --noconfirm worktrunk

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
