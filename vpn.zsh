#!/usr/bin/env zsh

set -e -o verbose

# packages

paru -S --aur --noconfirm \
  openvpn3

# connections

openvpn3 config-import \
  --config ~/code/keys/openvpn/apsis.ovpn \
  --name apsis \
  --persistent

# openvpn3 session-start --config apsis
# openvpn3 session-manage --config apsis --disconnect
# openvpn3 sessions-list
