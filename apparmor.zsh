#!/usr/bin/env zsh

set -o verbose

# https://github.com/Neo23x0/auditd https://github.com/roddhjav/apparmor.d

# packages

sudo pacman -S --noconfirm apparmor

# config

sudo sed -i \
  -e 's/#write-cache/write-cache/' \
  -e 's/#Optimize=compress-fast/Optimize=compress-fast/' \
  /etc/apparmor/parser.conf

# enable

for FILE in /boot/loader/entries/{arch,arch-lts}.conf; do
  sudo sed -i '/^options / {
    /audit=1/! s/$/ audit=1/
    /lsm=/! s/$/ lsm=landlock,lockdown,yama,integrity,apparmor,bpf/
  }' $FILE
done

sudo systemctl enable auditd.service apparmor.service

# disable

# for FILE in /boot/loader/entries/{arch,arch-lts}.conf; do
#   sudo sed -i '/^options / {
#     s/ audit=1//g
#     s/ lsm=[^ ]*//g
#   }' $FILE
# done
#
# sudo systemctl disable auditd.service apparmor.service

# cleanup

`dirname $0`/packages.sh

