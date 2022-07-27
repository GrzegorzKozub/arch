#!/usr/bin/env zsh

set -e -o verbose

# reset

sudo nft flush ruleset

# table

sudo nft add table inet filter_table

# chains and default policies

sudo nft add chain inet filter_table input_chain '{ type filter hook input priority 0 ; policy drop ; }'
sudo nft add chain inet filter_table forward_chain '{ type filter hook forward priority 0 ; policy drop ; }'
sudo nft add chain inet filter_table output_chain '{ type filter hook output priority 0 ; policy accept ; }'

# established, related and local connections

sudo nft add rule inet filter_table input_chain ct state related,established accept
sudo nft add rule inet filter_table input_chain iif lo accept

# invalid connections

sudo nft add rule inet filter_table input_chain ct state invalid drop

# ping

sudo nft add rule inet filter_table input_chain meta l4proto ipv6-icmp accept
sudo nft add rule inet filter_table input_chain meta l4proto icmp accept
sudo nft add rule inet filter_table input_chain ip protocol igmp accept

# tcp and udp

sudo nft add chain inet filter_table udp_chain
sudo nft add chain inet filter_table tcp_chain

sudo nft add rule inet filter_table input_chain meta l4proto udp ct state new jump udp_chain
sudo nft add rule inet filter_table input_chain 'meta l4proto tcp tcp flags & (fin|syn|rst|ack) == syn ct state new jump tcp_chain'

sudo nft add rule inet filter_table input_chain meta l4proto udp reject
sudo nft add rule inet filter_table input_chain meta l4proto tcp reject with tcp reset

# ssh

# sudo nft add rule inet filter_table tcp_chain tcp dport 22 accept

# http

# sudo nft add rule inet filter_table tcp_chain tcp dport 80 accept
# sudo nft add rule inet filter_table tcp_chain tcp dport 443 accept

# other connections

sudo nft add rule inet filter_table input_chain counter reject with icmpx port-unreachable

