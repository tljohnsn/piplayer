#!/bin/bash
# use with eth0 (jupiter) or wlan4 (wifihotspot)
echo routing through $1
iptables -t nat -D POSTROUTING 1
iptables -t nat -D POSTROUTING 1
iptables -t nat -D POSTROUTING 1
iptables -t nat -A POSTROUTING -o $1 -m iprange --src-range 10.0.4.1-10.0.4.170 -j MASQUERADE
iptables -t nat -A POSTROUTING -o $1 -m iprange --src-range 10.0.4.172-10.0.4.181 -j MASQUERADE
iptables -t nat -A POSTROUTING -o $1 -m iprange --src-range 10.0.4.183-10.0.4.255 -j MASQUERADE
netfilter-persistent save
