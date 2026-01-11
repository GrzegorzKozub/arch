#!/usr/bin/env bash

set -e

DIR=/boot/EFI/limine
[[ -d $DIR ]] || mkdir $DIR

# update limine on esp

cp /usr/share/limine/BOOTX64.EFI $DIR/liminex64.efi

# update resource file checksums in the config file

CFG=$DIR/limine.conf
TMP=$(mktemp)

cp $CFG $CFG.backup

while IFS= read -r line; do

  if [[ $line =~ boot\(\): ]]; then

    CFG_PATH=${line#*boot():} && CFG_PATH=${CFG_PATH%%#*}
    DISK_PATH="/boot$CFG_PATH"

    if [[ -f "$DISK_PATH" ]]; then
      echo "${line/$CFG_PATH*/}$CFG_PATH#$(b2sum "$DISK_PATH" | awk '{print $1}')"
    else
      echo "$line"
    fi

  else
    echo "$line"
  fi

done < $CFG > "$TMP"

mv "$TMP" $CFG
# rm $CFG.backup

# embded config file checksum in the executable

limine enroll-config \
  $DIR/liminex64.efi \
  "$(b2sum $DIR/limine.conf | awk '{print $1}')"

# sign the executable

[[ $(sbctl status --json | jq .installed) == 'true' ]] &&
  sbctl sign --save $DIR/liminex64.efi
