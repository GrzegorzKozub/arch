#!/usr/bin/env bash
set -eo pipefail -ux

if [[ ${1:-} == 'apsis' ]]; then

  # packages

  yay --aur --noconfirm --answerdiff=None -S \
    openvpn3

  # connections

  openvpn3 config-import \
    --config ~/code/keys/openvpn/apsis.ovpn \
    --name apsis \
    --persistent

  sudo sed -i \
    's#^Exec=/usr/lib/openvpn3-linux/openvpn3-service-netcfg --state-dir "/var/lib/openvpn3"$#Exec=/usr/lib/openvpn3-linux/openvpn3-service-netcfg --state-dir "/var/lib/openvpn3" --systemd-resolved#' \
    /usr/share/dbus-1/system-services/net.openvpn.v3.netcfg.service

  sudo systemctl reload dbus-broker.service

  # openvpn3 session-start --config apsis
  # openvpn3 session-manage --config apsis --disconnect
  # openvpn3 sessions-list

fi

if [[ ${1:-} == 'audience' ]]; then

  # packages

  sudo pacman -S --noconfirm \
    libnma \
    strongswan \
    networkmanager-strongswan

    # nm-connection-editor

  # connections

  DIR=~/code/keys/strongswan

  declare -A ENVS=(
    [stage]='ec2-54-217-117-208.eu-west-1.compute.amazonaws.com 10.103.11.234'
    [beta]='ec2-176-34-136-50.eu-west-1.compute.amazonaws.com 10.104.11.228'
    [prod]='ec2-18-203-8-221.eu-west-1.compute.amazonaws.com 10.105.11.249'
    [prod - apac]='ec2-52-221-141-135.ap-southeast-1.compute.amazonaws.com 10.107.11.60'
  )

  for ENV in "${!ENVS[@]}"; do

    read -ra PROPS <<< "${ENVS[$ENV]}"
    CONN="audience-$ENV"

    nmcli connection | grep -q "$CONN " && nmcli connection delete "$CONN"

    nmcli connection add type vpn vpn-type strongswan con-name "$CONN"

    nmcli connection modify "$CONN" +vpn.data address="${PROPS[0]}"
    nmcli connection modify "$CONN" +vpn.data certificate="$DIR/$CONN-ca.pem"

    nmcli connection modify "$CONN" +vpn.data method=cert
    nmcli connection modify "$CONN" +vpn.data usercert="$DIR/$CONN-cert.pem"
    nmcli connection modify "$CONN" +vpn.data userkey="$DIR/$CONN-key.pem"

    nmcli connection modify "$CONN" +vpn.data virtual=yes

    nmcli connection modify "$CONN" ipv4.dns "${PROPS[1]}"
    nmcli connection modify "$CONN" ipv4.dns-search "$ENV.aud, $ENV.email, $ENV.ma, $ENV.mta, $ENV.sms, $ENV.webscript, internal, redshift.amazonaws.com"

  done

fi

if [[ ${1:-} == 'webscript' ]]; then

  # packages

  sudo pacman -S --noconfirm \
    libnma \
    networkmanager-openvpn \
    openvpn

  # connections

  for FILE in ~/code/keys/openvpn/webscript-*.ovpn; do

    CONN=$(basename -- "$FILE" .ovpn)

    nmcli connection | grep -q "$CONN " && nmcli connection delete "$CONN"

    nmcli connection import type openvpn file "$FILE"
    nmcli connection modify "$CONN" +vpn.data password-flags=2

  done

  # nmcli connection up webscript-stage --ask

fi
