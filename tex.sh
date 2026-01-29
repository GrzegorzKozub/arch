#!/usr/bin/env bash
set -eo pipefail -ux

# packages

sudo pacman -S --noconfirm \
  texlive-basic \
  texlive-latex \
  texlive-latexrecommended texlive-latexextra \
  texlive-fontsrecommended texlive-fontsextra \
  texlive-luatex \
  texlive-plaingeneric

# links

cp /usr/share/applications/xdvi.desktop $XDG_DATA_HOME/applications
sed -i '2iNoDisplay=true' $XDG_DATA_HOME/applications/xdvi.desktop

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
