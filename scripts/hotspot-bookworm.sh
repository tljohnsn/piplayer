#!/bin/bash
#/etc/NetworkManager/NetworkManager.conf
#[main]
#dns=dnsmasq
#
#systemctl disable dnsmasq
#systemctl stop dnsmasq


nmcli con delete preconfigured
nmcli con delete wlanboard
nmcli con delete TEST-AP

nmcli con add type wifi ifname wlanboard mode ap con-name TEST-AP ssid tunes2 autoconnect true
nmcli con modify TEST-AP 802-11-wireless.band bg
nmcli con modify TEST-AP 802-11-wireless.channel 3
nmcli con modify TEST-AP 802-11-wireless.cloned-mac-address B8:27:EB:C4:F4:4E
nmcli con modify TEST-AP ipv4.method shared ipv4.address 192.168.4.1/24
nmcli con modify TEST-AP ipv6.method disabled
nmcli con modify TEST-AP wifi-sec.key-mgmt wpa-psk
nmcli con modify TEST-AP wifi-sec.psk "9e6a188321"
