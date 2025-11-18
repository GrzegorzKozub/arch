#!/usr/bin/env zsh

set -e -o verbose

sudo systemctl enable --now systemd-resolved
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

sudo nvim /etc/systemd/resolved.conf
DNS=1.1.1.1#cloudflare-dns.com 1.0.0.1#cloudflare-dns.com
Domains=~.
DNSOverTLS=opportunistic


maybe other file
/etc/systemd/resolved.conf.d/dns_over_tls.conf
[Resolve]
DNS=9.9.9.9#dns.quad9.net 149.112.112.112#dns.quad9.net 2620:fe::fe#dns.quad9.net 2620:fe::9#dns.quad9.net
DNSOverTLS=yes
Domains=~.



/etc/NetworkManager/conf.d/dns.conf
[main]
dns=systemd-resolved
[connection]
connection.mdns=2


nmcli connection modify Wired\ connection\ 1 ipv4.ignore-auto-dns yes


test nmcli connection modify interface_name connection.mdns {yes|no|resolve}
test connection.dns-over-tls=2
