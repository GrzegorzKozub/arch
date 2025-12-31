#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -Sy --noconfirm \
  pam-u2f

# config

DIR=$XDG_CONFIG_HOME/Yubico

[[ -d $DIR ]] || mkdir -p $DIR
pamu2fcfg -o pam://$HOST -i pam://$HOST > $DIR/u2f_keys

FILE=/etc/pam.d/gdm-password

YUBIKEY="auth       sufficient                  pam_u2f.so origin=pam://$HOST appid=pam://$HOST"
  LOGIN="auth       include                     system-local-login"

grep -Fxq $YUBIKEY $FILE || sudo sed -i "/^$LOGIN$/i $YUBIKEY" $FILE

