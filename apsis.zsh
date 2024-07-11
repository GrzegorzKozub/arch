#!/usr/bin/env zsh

set -o verbose

# hosts

sudo sed -i -e '/.*apsis.*/d' -e '/.*stage.*/d' -e '/.*amazonaws.*/d' /etc/hosts

echo '127.0.0.1 int.aud-stage.apsis.cloud' | sudo tee --append /etc/hosts > /dev/null
echo '::1       int.aud-stage.apsis.cloud' | sudo tee --append /etc/hosts > /dev/null

echo '127.0.0.1 alb-int.aud-stage.apsis.cloud' | sudo tee --append /etc/hosts > /dev/null
echo '::1       alb-int.aud-stage.apsis.cloud' | sudo tee --append /etc/hosts > /dev/null

echo '127.0.0.1 api.stage.ma' | sudo tee --append /etc/hosts > /dev/null
echo '::1       api.stage.ma' | sudo tee --append /etc/hosts > /dev/null

echo '127.0.0.1 dev.apsis' | sudo tee --append /etc/hosts > /dev/null
echo '::1       dev.apsis' | sudo tee --append /etc/hosts > /dev/null

echo '127.0.0.1 ANUNLB-LB-VC5YGOQNTGG4-7707d28b7ca45024.elb.eu-west-1.amazonaws.com' | sudo tee --append /etc/hosts > /dev/null
echo '::1       ANUNLB-LB-VC5YGOQNTGG4-7707d28b7ca45024.elb.eu-west-1.amazonaws.com' | sudo tee --append /etc/hosts > /dev/null
