#!/usr/bin/env zsh

set -e -o verbose

# reset

sudo iptables -Z
sudo iptables -F
sudo iptables -X

sudo iptables -t nat -Z
sudo iptables -t nat -F
sudo iptables -t nat -X

sudo iptables -t mangle -Z
sudo iptables -t mangle -F
sudo iptables -t mangle -X

sudo iptables -t raw -Z
sudo iptables -t raw -F
sudo iptables -t raw -X

sudo iptables -t security -Z
sudo iptables -t security -F
sudo iptables -t security -X

sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT

# default policies

sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT

# established, related and local connections

sudo iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -i lo -j ACCEPT

# invalid connections

sudo iptables -A INPUT -m conntrack --ctstate INVALID -j DROP

# ping

sudo iptables -A INPUT -p icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT

# tcp and udp

sudo iptables -N UDP
sudo iptables -N TCP

sudo iptables -A INPUT -p udp -m conntrack --ctstate NEW -j UDP
sudo iptables -A INPUT -p tcp --syn -m conntrack --ctstate NEW -j TCP

sudo iptables -A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable
sudo iptables -A INPUT -p tcp -j REJECT --reject-with tcp-reset

# ssh

# sudo iptables -A TCP -p tcp --dport 22 -j ACCEPT

# http

# sudo iptables -A TCP -p tcp --dport 80 -j ACCEPT
# sudo iptables -A TCP -p tcp --dport 443 -j ACCEPT

# syn scans

sudo iptables -I TCP -p tcp -m recent --update --rsource --seconds 60 --name TCP-PORTSCAN -j REJECT --reject-with tcp-reset

sudo iptables -D INPUT -p tcp -j REJECT --reject-with tcp-reset
sudo iptables -A INPUT -p tcp -m recent --set --rsource --name TCP-PORTSCAN -j REJECT --reject-with tcp-reset

# udp scans

sudo iptables -I UDP -p udp -m recent --update --rsource --seconds 60 --name UDP-PORTSCAN -j REJECT --reject-with icmp-port-unreachable

sudo iptables -D INPUT -p udp -j REJECT --reject-with icmp-port-unreachable
sudo iptables -A INPUT -p udp -m recent --set --rsource --name UDP-PORTSCAN -j REJECT --reject-with icmp-port-unreachable

# other connections

sudo iptables -A INPUT -j REJECT --reject-with icmp-proto-unreachable

# save

sudo iptables-save -f `dirname $0`/etc/iptables/iptables.rules

