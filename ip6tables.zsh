#!/usr/bin/env zsh

set -e -o verbose

# reset

sudo ip6tables -Z
sudo ip6tables -F
sudo ip6tables -X

sudo ip6tables -t nat -Z
sudo ip6tables -t nat -F
sudo ip6tables -t nat -X

sudo ip6tables -t mangle -Z
sudo ip6tables -t mangle -F
sudo ip6tables -t mangle -X

sudo ip6tables -t raw -Z
sudo ip6tables -t raw -F
sudo ip6tables -t raw -X

sudo ip6tables -t security -Z
sudo ip6tables -t security -F
sudo ip6tables -t security -X

sudo ip6tables -P INPUT ACCEPT
sudo ip6tables -P FORWARD ACCEPT
sudo ip6tables -P OUTPUT ACCEPT

# default policies

sudo ip6tables -P INPUT DROP
sudo ip6tables -P FORWARD DROP
sudo ip6tables -P OUTPUT ACCEPT

# established, related and local connections

sudo ip6tables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo ip6tables -A INPUT -i lo -j ACCEPT

# invalid connections

sudo ip6tables -A INPUT -m conntrack --ctstate INVALID -j DROP

# ping

sudo ip6tables -A INPUT -p ipv6-icmp --icmpv6-type 128 -m conntrack --ctstate NEW -j ACCEPT

# tcp and udp

sudo ip6tables -N UDP
sudo ip6tables -N TCP

sudo ip6tables -A INPUT -p udp -m conntrack --ctstate NEW -j UDP
sudo ip6tables -A INPUT -p tcp --syn -m conntrack --ctstate NEW -j TCP

sudo ip6tables -A INPUT -p udp -j REJECT --reject-with icmp6-adm-prohibited
sudo ip6tables -A INPUT -p tcp -j REJECT --reject-with tcp-reset

# ssh

# sudo ip6tables -A TCP -p tcp --dport 22 -j ACCEPT

# http

# sudo ip6tables -A TCP -p tcp --dport 80 -j ACCEPT
# sudo ip6tables -A TCP -p tcp --dport 443 -j ACCEPT

# syn scans

sudo ip6tables -I TCP -p tcp -m recent --update --rsource --seconds 60 --name TCP-PORTSCAN -j REJECT --reject-with tcp-reset

sudo ip6tables -D INPUT -p tcp -j REJECT --reject-with tcp-reset
sudo ip6tables -A INPUT -p tcp -m recent --set --rsource --name TCP-PORTSCAN -j REJECT --reject-with tcp-reset

# udp scans

sudo ip6tables -I UDP -p udp -m recent --update --rsource --seconds 60 --name UDP-PORTSCAN -j REJECT --reject-with icmp6-adm-prohibited

sudo ip6tables -D INPUT -p udp -j REJECT --reject-with icmp6-adm-prohibited
sudo ip6tables -A INPUT -p udp -m recent --set --rsource --name UDP-PORTSCAN -j REJECT --reject-with icmp6-adm-prohibited

# reverse path filtering

sudo ip6tables -t raw -A PREROUTING -m rpfilter -j ACCEPT
sudo ip6tables -t raw -A PREROUTING -j DROP

# other connections

sudo ip6tables -A INPUT -j REJECT --reject-with icmp6-adm-prohibited

# save

sudo ip6tables-save -f `dirname $0`/etc/iptables/ip6tables.rules

