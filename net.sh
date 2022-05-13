#!/bin/sh

until [[ $(ping -c 1 -t 32 github.com 2> /dev/null | grep '1 received') ]]; do
  echo 'no internet'
  sleep 15
done

sleep 15

