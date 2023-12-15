#!/bin/bash
cd /home/pi
apt -y install gpsd gpsd-clients scons libncurses5-dev
source /etc/os-release
if [ "$VERSION_CODENAME" != "bookworm" ]; then
wget https://download-mirror.savannah.gnu.org/releases/gpsd/gpsd-3.25.tar.xz
tar -xf gpsd-3.25.tar.xz
cd gpsd-3.25
scons
cp ./gpsd-3.25/gpsd/gpsd /usr/sbin

systemctl stop gpsd.socket
systemctl stop gpsd.service

systemctl disable gpsd.socket
systemctl disable gpsd.service

systemctl mask gpsd.socket
systemctl mask gpsd.service
fi
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

