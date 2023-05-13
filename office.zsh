#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  libreoffice-fresh \
  hunspell hunspell-en_us \
  hyphen hyphen-en \
  libmythes mythes-en

sudo sed -i -e 's/Logo=1/Logo=0/' /etc/libreoffice/sofficerc

# links

for APP in \
  libreoffice-base \
  libreoffice-draw \
  libreoffice-impress \
  libreoffice-math \
  libreoffice-startcenter \
  libreoffice-xsltfilter
do
  cp /usr/share/applications/$APP.desktop $XDG_DATA_HOME/applications
  sed -i '2iNoDisplay=true' $XDG_DATA_HOME/applications/$APP.desktop
done

for APP in \
  libreoffice-calc \
  libreoffice-writer
do
  cp /usr/share/applications/$APP.desktop $XDG_DATA_HOME/applications
  sed -i -e 's/^Name=LibreOffice /Name=/' $XDG_DATA_HOME/applications/$APP.desktop
done

