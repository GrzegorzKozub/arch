#!/usr/bin/env zsh

set -e -o verbose

if [[ $1 == 'apsis' ]]; then

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

fi

if [[ $1 == 'audience' ]]; then

  # packages

  sudo pacman -S --noconfirm \
    libnma \
    strongswan \
    networkmanager-strongswan

    # nm-connection-editor

  # connections

  DIR=~/code/keys/strongswan

  typeset -A ENVS=(
    'stage' 'ec2-54-217-117-208.eu-west-1.compute.amazonaws.com'
    'beta' 'ec2-176-34-136-50.eu-west-1.compute.amazonaws.com'
    'prod' 'ec2-18-203-8-221.eu-west-1.compute.amazonaws.com'
    'prod-apac' 'ec2-52-221-141-135.ap-southeast-1.compute.amazonaws.com'
  )

  for ENV ADDR ("${(@kv)ENVS}"); do

    CONN="audience-$ENV"

    [[ $(nmcli connection | grep "$CONN ") ]] && nmcli connection delete $CONN

    nmcli connection add type vpn vpn-type strongswan con-name $CONN

    nmcli connection modify $CONN +vpn.data address=$ADDR
    nmcli connection modify $CONN +vpn.data certificate=$DIR/$CONN-ca.pem

    nmcli connection modify $CONN +vpn.data method=cert
    nmcli connection modify $CONN +vpn.data usercert=$DIR/$CONN-cert.pem
    nmcli connection modify $CONN +vpn.data userkey=$DIR/$CONN-key.pem

    nmcli connection modify $CONN +vpn.data virtual=yes

    [[ $ENV == 'stage' ]] && nmcli connection modify $CONN ipv4.dns '10.103.11.234'
    [[ $ENV == 'beta' ]] && nmcli connection modify $CONN ipv4.dns '10.104.11.228'
    [[ $ENV == 'prod' ]] && nmcli connection modify $CONN ipv4.dns '10.105.11.249'
    [[ $ENV == 'prod-apac' ]] && nmcli connection modify $CONN ipv4.dns '10.107.11.60'

  done

fi

if [[ $1 == 'webscript' ]]; then

  # packages

  sudo pacman -S --noconfirm \
    libnma \
    networkmanager-openvpn \
    openvpn

  # connections

  for FILE in ~/code/keys/openvpn/webscript-*.ovpn; do

    CONN=$(basename -- $FILE .ovpn)

    [[ $(nmcli connection | grep "$CONN ") ]] && nmcli connection delete $CONN

    nmcli connection import type openvpn file $FILE
    nmcli connection modify $CONN +vpn.data password-flags=2

  done

  # nmcli connection up webscript-stage --ask

fi
