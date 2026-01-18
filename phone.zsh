#!/usr/bin/env zsh

set -e

[[ $(pacman -Qqs gvfs-mtp) ]] || sudo pacman -S --noconfirm gvfs-mtp
[[ $(pacman -Qqs mtpfs) ]] || sudo pacman -S --noconfirm mtpfs
[[ $(pacman -Qqs jmtpfs) ]] || paru -S --aur --noconfirm jmtpfs

MUSIC=/run/media/greg/data/music
PHONE=~/phone

[[ -d $PHONE ]] || mkdir $PHONE

jmtpfs $PHONE -o nonempty

TRAPINT() { }
TRAPEXIT() { sleep 3 && fusermount -u $PHONE && rm -rf $PHONE }

rclone sync \
  --progress \
  $MUSIC "$PHONE/Internal shared storage/Music"

