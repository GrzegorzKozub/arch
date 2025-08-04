#!/usr/bin/env zsh

# set -e

TMP="$(mktemp)"

YT=/run/media/$USER/data/music/YouTube
[[ -d $YT ]] || mkdir $YT

rm -rf $YT/*

pushd $YT

yt-dlp \
  --format bestaudio \
  --extract-audio --audio-format flac --audio-quality 0 \
  --parse-metadata "title:%(artist)s - %(title)s" \
  --parse-metadata "%(album|YouTube)s:%(album)s" \
  --embed-metadata \
  --convert-thumbnail png --write-thumbnail \
  --no-write-playlist-metafiles \
  --print-to-file filename $TMP \
  --paths $YT --output "%(artist)s - %(title)s.%(ext)s" --windows-filenames \
  'https://music.youtube.com/watch?v=pyZLUGcYJx8'
  # 'https://music.youtube.com/watch?v=qR9kvbXt4tk'
  # 'https://music.youtube.com/playlist?list=LM'
  # --print-to-file fulltitle $TMP \

# for file in *; do [[ $file == *⧸* ]] && mv -- "$file" "${file//⧸/ }"; done
# sed -ie "s/$(echo -e "\xE2\xA7\xB8")/ /g" $TMP

echo $TMP
cat $TMP

while read -r title; do

  mv "$title.png" original.png
  mv "$title.flac" original.flac

  ffmpeg \
    -i original.png \
    -vf "crop='min(in_w\,in_h)':'min(in_w\,in_h)':(in_w-min(in_w\,in_h))/2:(in_h-min(in_w\,in_h))/2" \
    square.png

  ffmpeg \
    -i original.flac -i square.png \
    -map 0 -map 1 -c copy -disposition:v attached_pic \
    "$title.flac"

  # rm original.flac original.png square.png

done < $TMP

popd

