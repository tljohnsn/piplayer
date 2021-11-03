#!/bin/bash
# use with eth0 (jupiter) or wlan4 (wifihotspot)
iptables -t nat -D POSTROUTING 1
iptables -t nat -D POSTROUTING 1
iptables -t nat -D POSTROUTING 1
iptables -t nat -A POSTROUTING -o eth0 -m iprange --src-range 192.168.77.1-192.168.77.150 -j MASQUERADE
iptables -t nat -A POSTROUTING -o eth0 -m iprange --src-range 192.168.77.153-192.168.77.255 -j MASQUERADE
iptables -t nat -A POSTROUTING -o eth0 -m iprange --src-range 192.168.5.1-192.168.5.255 -j MASQUERADE
