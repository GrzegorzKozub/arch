#!/usr/bin/env zsh

# set -e

GAMES=/run/media/greg/data/music/Games

[[ -d $GAMES ]] || mkdir $GAMES


rm -rf ~/Downloads/*

yt-dlp \
  --skip-download \
  --write-thumbnail \
  --convert-thumbnail png \
  --parse-metadata "title:%(artist)s - %(title)s" \
  --output "%(artist)s - %(title)s.%(ext)s" \
  'https://www.youtube.com/watch?v=aY-LU9SpEvE'

THUMB=$(find *.png | head -n 1)
echo $THUMB
mv $THUMB o$THUMB

ffmpeg \
  -y \
  -i o$THUMB \
  -vf "crop='min(in_w\,in_h)':'min(in_w\,in_h)':(in_w-min(in_w\,in_h))/2:(in_h-min(in_w\,in_h))/2" \
  $THUMB

yt-dlp \
  --format bestaudio \
  --extract-audio --audio-format flac --audio-quality 0 \
  --parse-metadata "title:%(artist)s - %(title)s" \
  --parse-metadata "%(album|Games)s:%(album)s" \
  --embed-metadata \
  --keep-fragments \
  --paths ~/Downloads \
  --output "%(artist)s - %(title)s.%(ext)s" \
  'https://www.youtube.com/watch?v=aY-LU9SpEvE'
  # --embed-thumbnail \

V=$(find *.flac | head -n 1)
T=$(find *.png | head -n 1)

ffmpeg -y -i "$V" -i "$T" -map 0 -map 1 -c copy -disposition:v attached_pic output.flac
