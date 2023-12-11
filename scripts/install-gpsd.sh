#!/bin/bash
apt -y install gpsd gpsd-clients

systemctl stop gpsd.socket
systemctl stop gpsd.service

systemctl disable gpsd.socket
systemctl disable gpsd.service

systemctl mask gpsd.socket
systemctl mask gpsd.service

if [ `grep -c 127.127.28.0 /etc/ntp.conf` -lt 1 ]; then
echo "
server 127.127.28.0 prefer
fudge 127.127.28.0 flag1 1 refid PPS
" | sudo tee -a /etc/ntp.conf
fi

if [ `grep -c 127.127.28.0 /etc/ntpsec/ntp.conf` -lt 1 ]; then
echo "
server 127.127.28.0 prefer
fudge 127.127.28.0 flag1 1 refid PPS
" | sudo tee -a /etc/ntpsec/ntp.conf
fi

#test with
#gpsd /dev/ttyACM0 -G -n -N

