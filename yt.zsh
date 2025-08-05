#!/usr/bin/env zsh

# set -e

YT=/run/media/$USER/data/music/YouTube
[[ -d $YT ]] || mkdir $YT
rm -rf $YT/*
pushd $YT

TMP="$(mktemp)"

yt-dlp \
  --format bestaudio \
  --extract-audio --audio-format flac --audio-quality 0 \
  --parse-metadata 'title:%(artist)s - %(title)s' \
  --parse-metadata '%(album|YouTube)s:%(album)s' \
  --parse-metadata ':(?P<meta_synopsis>)' \
  --embed-metadata \
  --convert-thumbnail png --write-thumbnail \
  --no-write-playlist-metafiles \
  --paths $YT --output '%(artist)s - %(title)s.%(ext)s' --windows-filenames \
  --print-to-file filename $TMP \
  'https://music.youtube.com/browse/VLPLm6VwE4tgUkXEcczHuW9xiwGJwHvq69ri'
  # 'https://music.youtube.com/playlist?list=LM'

sed -i -e "s#$YT/##" -e 's/\.webm//' $TMP

while read -r title; do

  mv "$title.png" original.png
  mv "$title.flac" original.flac

  ffmpeg \
    -i original.png \
    -vf "crop='min(in_w\,in_h)':'min(in_w\,in_h)':(in_w-min(in_w\,in_h))/2:(in_h-min(in_w\,in_h))/2,scale=1280:1280" \
    square.png

  ffmpeg \
    -i original.flac -i square.png \
    -map 0 -map 1 -c copy -disposition:v attached_pic \
    "$title.flac"

  rm original.flac original.png square.png

done < $TMP

rm $TMP

popd

