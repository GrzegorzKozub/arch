#!/usr/bin/env zsh

set -e -o verbose

sudo systemctl enable --now systemd-resolved
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

sudo nvim /etc/systemd/resolved.conf
DNS=1.1.1.1#cloudflare-dns.com 1.0.0.1#cloudflare-dns.com
FallbackDNS=9.9.9.9 149.112.112.112
DNSOverTLS=opportunistic

mDNS-IPv6: There appears to be another mDNS responder running, or previously systemd-resolved crashed with some outstanding transfers
Using degraded feature set UDP+EDNS0 instead of TLS+EDNS0 for DNS server 91.202.124.30.


