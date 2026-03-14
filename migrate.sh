#!/usr/bin/env bash
set -eo pipefail -ux

# docx2txt

sudo pacman -S --noconfirm docx2txt

# worktrunk

sudo pacman -S --noconfirm worktrunk

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
