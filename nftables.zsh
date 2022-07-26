#!/usr/bin/env zsh

set -e -o verbose

# reset

nft flush ruleset

# table

nft add table inet my_table

# chains and default policies

nft add chain inet my_table my_input '{ type filter hook input priority 0 ; policy drop ; }'
nft add chain inet my_table my_forward '{ type filter hook forward priority 0 ; policy drop ; }'
nft add chain inet my_table my_output '{ type filter hook output priority 0 ; policy accept ; }'

# established, related and local connections

nft add rule inet my_table my_input ct state related,established accept
nft add rule inet my_table my_input iif lo accept

# invalid connections

nft add rule inet my_table my_input ct state invalid drop

# ping

nft add rule inet my_table my_input meta l4proto ipv6-icmp accept
nft add rule inet my_table my_input meta l4proto icmp accept
nft add rule inet my_table my_input ip protocol igmp accept

# tcp and udp

nft add chain inet my_table my_udp_chain
nft add chain inet my_table my_tcp_chain

nft add rule inet my_table my_input meta l4proto udp ct state new jump my_udp_chain
nft add rule inet my_table my_input 'meta l4proto tcp tcp flags & (fin|syn|rst|ack) == syn ct state new jump my_tcp_chain'

# reject everything else

nft add rule inet my_table my_input meta l4proto udp reject
nft add rule inet my_table my_input meta l4proto tcp reject with tcp reset
nft add rule inet my_table my_input counter reject with icmpx port-unreachable

# ssh

# nft add rule inet my_table my_tcp_chain tcp dport 22 accept

# http

# nft add rule inet my_table my_tcp_chain tcp dport 80 accept
# nft add rule inet my_table my_tcp_chain tcp dport 443 accept

