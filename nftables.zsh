#!/usr/bin/env zsh

set -e -o verbose

# reset

sudo nft flush ruleset

# table

sudo nft add table inet my_table

# chains and default policies

sudo nft add chain inet my_table my_input '{ type filter hook input priority 0 ; policy drop ; }'
sudo nft add chain inet my_table my_forward '{ type filter hook forward priority 0 ; policy drop ; }'
sudo nft add chain inet my_table my_output '{ type filter hook output priority 0 ; policy accept ; }'

# established, related and local connections

sudo nft add rule inet my_table my_input ct state related,established accept
sudo nft add rule inet my_table my_input iif lo accept

# invalid connections

sudo nft add rule inet my_table my_input ct state invalid drop

# ping

sudo nft add rule inet my_table my_input meta l4proto ipv6-icmp accept
sudo nft add rule inet my_table my_input meta l4proto icmp accept
sudo nft add rule inet my_table my_input ip protocol igmp accept

# tcp and udp

sudo nft add chain inet my_table my_udp_chain
sudo nft add chain inet my_table my_tcp_chain

sudo nft add rule inet my_table my_input meta l4proto udp ct state new jump my_udp_chain
sudo nft add rule inet my_table my_input 'meta l4proto tcp tcp flags & (fin|syn|rst|ack) == syn ct state new jump my_tcp_chain'

sudo nft add rule inet my_table my_input meta l4proto udp reject
sudo nft add rule inet my_table my_input meta l4proto tcp reject with tcp reset

# ssh

# sudo nft add rule inet my_table my_tcp_chain tcp dport 22 accept

# http

# sudo nft add rule inet my_table my_tcp_chain tcp dport 80 accept
# sudo nft add rule inet my_table my_tcp_chain tcp dport 443 accept

# other connections

sudo nft add rule inet my_table my_input counter reject with icmpx port-unreachable

