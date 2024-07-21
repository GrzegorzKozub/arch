#!/usr/bin/env zsh

set -o verbose

# hosts

HOSTS=(
  'int.aud-stage.apsis.cloud'
  'alb-int.aud-stage.apsis.cloud'
  'api.stage.ma'
  'dev.apsis'
  'ANUNLB-LB-VC5YGOQNTGG4-7707d28b7ca45024.elb.eu-west-1.amazonaws.com'
)

for HOST in $HOSTS; do
  sudo sed -i -e "/.*$HOST.*/d" /etc/hosts
done

for HOST in $HOSTS; do
  echo "127.0.0.1 $HOST\n::1       $HOST" | sudo tee --append /etc/hosts > /dev/null
done
