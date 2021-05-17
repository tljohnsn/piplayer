#!/bin/bash
sed -i -e "s/^interface wlanboard/#interface wlanboard/" \
    -e "s%^   static ip_address=192.168.5.1/24%#   static ip_address=192.168.5.1/24%" \
    -e "s/^   nohook wpa_supplicant/#   nohook wpa_supplicant/" /etc/dhcpcd.conf


mv /etc/dnsmasq.conf.orig /etc/dnsmasq.conf
mv /etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf.old
