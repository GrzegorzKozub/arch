#!/usr/bin/env zsh

set -o verbose

# hosts

HOSTS=(
  '8favxfpaq6.execute-api.eu-west-1.amazonaws.com'
  'ANUNLB-LB-VC5YGOQNTGG4-7707d28b7ca45024.elb.eu-west-1.amazonaws.com'
  'WAWNLB2-LB-2KEW9GHX6ZHK-3cd7f3576423cce8.elb.eu-west-1.amazonaws.com'
  'WAWNLB2-LB-BFAMMO58AJC7-ac1f28233c0b6fc5.elb.eu-west-1.amazonaws.com'
  'alb-int.aud-stage.apsis.cloud'
  'api.stage.ma'
  'capturetool.ecs-stage.webscript'
  'dev.apsis'
  'formtoolbackend.ecs-stage.webscript'
  'hls.aud-stage.apsis.cloud'
  'int.aud-stage.apsis.cloud'
  'int.email-stage.apsis.cloud'
  'int.folders-stage.apsis.cloud'
  'integrations-stage.apsis.cloud'
)

for HOST in $HOSTS; do
  sudo sed -i -e "/.*$HOST.*/d" /etc/hosts
done

for HOST in $HOSTS; do
  echo "127.0.0.1 $HOST\n::1       $HOST" | sudo tee --append /etc/hosts > /dev/null
done
