#!/usr/bin/env bash

set -e -o verbose

# format

cp /etc/fstab /etc/fstab.bak
column --table /etc/fstab.bak | sed 's/^# */# /' > /etc/fstab
rm /etc/fstab.bak
