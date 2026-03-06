#!/usr/bin/env bash
set -eo pipefail -ux

# format

cp /etc/fstab /etc/fstab.bak
column --table /etc/fstab.bak | sed -e 's/^# */# /' -e 's/ *$//' > /etc/fstab
rm /etc/fstab.bak
