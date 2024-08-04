#!/usr/bin/env zsh

set -e -o verbose

# mdbook

sudo pacman -S --noconfirm \
  mdbook

paru -S --aur --noconfirm \
  epub-tools-bin \
  kepubify-bin \
  pandoc-bin

cargo install mdbook-pandoc

# foliate

# sudo pacman -S --noconfirm \
#   foliate

# calibre

# sudo pacman -S --noconfirm \
#   calibre
#
# for APP in \
#   calibre-ebook-edit \
#   calibre-ebook-viewer \
#   calibre-lrfviewer
# do
#   cp /usr/share/applications/$APP.desktop $XDG_DATA_HOME/applications
#   sed -i '2iNoDisplay=true' $XDG_DATA_HOME/applications/$APP.desktop
# done

# dotfiles

# . ~/code/dotfiles/books.zsh
