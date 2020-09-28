#!/bin/bash
device=`ip -o link list |grep "wlan[0-9]: <NO-CARRIER" | cut -d : -f 2 |sed -e "s/\s//g"`
if [ `ip -o link list | grep -c "$device: <NO-CARRIER"` -gt 0 ]; then
    echo "Starting wpa_supplicant@$device"
    systemctl start wpa_supplicant@$device
fi
