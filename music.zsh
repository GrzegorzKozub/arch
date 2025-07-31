#!/usr/bin/env zsh

set -e -o verbose

# packages

paru -S --aur --noconfirm \
  tidal-hifi-bin

●• sudo pacman -Q gvfs-mtp mtpfs gvfs
gvfs-mtp 1.57.2-4
mtpfs 1.1-5
gvfs 1.57.2-4


paru jmtpfs


jmtpfs phone
rclone sync --exclude 'Games/**' --progress /run/media/greg/data/music/ ~/Downloads/phone/Internal\ shared\ storage/Music
 fusermount -u phone

yt-dlp -f bestaudio --extract-audio --embed-thumbnail --audio-format flac 'https://music.youtube.com/playlist?list=OLAK5uy_nU3noFgu2E0XWaBaIbxjQkBGNyJjM_6W0'



