#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  texlive-basic \
  texlive-latex \
  texlive-latexrecommended texlive-latexextra \
  texlive-fontsrecommended \
  texlive-luatex

# links

for APP in \
  xdvi
do
  cp /usr/share/applications/$APP.desktop $XDG_DATA_HOME/applications
  sed -i '2iNoDisplay=true' $XDG_DATA_HOME/applications/$APP.desktop
done

# cleanup

. `dirname $0`/packages.zsh

