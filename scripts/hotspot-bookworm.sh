#!/bin/bash
#/etc/NetworkManager/NetworkManager.conf
#[main]
#dns=dnsmasq
#
#systemctl disable dnsmasq
#systemctl stop dnsmasq
export create_wifi_network=pi
export create_wifi_password=9e6a188321

source /boot/firmware/tunes.txt

#nmcli con delete preconfigured
#nmcli con delete wlanboard
#nmcli con delete TEST-AP

#watch -c -n 1 "sudo nmcli device wifi rescan ifname wlan3; sudo nmcli --color yes device wifi list ifname wlan3"

#sudo nmcli device wifi connect Jupiter --ask ifname wlan1
#
#nmcli con add type wifi ifname wlan0 mode ap con-name TEST-AP ssid pi autoconnect true
#nmcli con modify TEST-AP 802-11-wireless.band bg
#nmcli con modify TEST-AP 802-11-wireless.channel 3
#nmcli con modify TEST-AP 802-11-wireless.cloned-mac-address B8:27:EB:C4:F4:4E
#nmcli con modify TEST-AP ipv4.method shared ipv4.address 192.168.4.1/24
#nmcli con modify TEST-AP ipv6.method disabled
#nmcli con modify TEST-AP wifi-sec.key-mgmt wpa-psk
#nmcli con modify TEST-AP wifi-sec.psk "9e6a188321"

#sudo nmcli device wifi hotspot ifname wlan0 ssid pi password 9e6a188321
#sudo nmcli con mod Hotspot  autoconnect true

#sudo nmcli connection add type wifi con-name ArubaPhone11 ifname wlan1 ssid "ArubaPhone11" wifi-sec.key-mgmt wpa-psk wifi-sec.psk "9e6a188321"
#sudo nmcli device wifi rescan ifname wlan1
#sudo nmcli device wifi list   ifname wlan1
#sudo nmcli con mod preconfigured connection.interface-name ArubaPhone11

sudo nmcli device wifi hotspot ifname wlanboard con-name "$create_wifi_network" ssid "$create_wifi_network"  password "$create_wifi_password"
sudo nmcli con mod "$create_wifi_network" autoconnect true
nmcli dev wifi show-password


if [ ! -z "$join_wifi_password" ]; then
    sudo nmcli device wifi connect $join_wifi_network password "$join_wifi_password" ifname wlan1
else
    sudo nmcli device wifi connect $join_wifi_network --ask ifname wlan1
fi

sudo nmcli con mod preconfigured connection.interface-name wlan1

