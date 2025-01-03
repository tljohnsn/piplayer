#!/bin/bash
cd /home/pi
apt -y install gpsd gpsd-clients scons libncurses5-dev cimg-dev libdatetime-perl
source /etc/os-release
if [ "$VERSION_CODENAME" != "anything" ]; then
wget https://download-mirror.savannah.gnu.org/releases/gpsd/gpsd-3.25.tar.xz
tar -xf gpsd-3.25.tar.xz
cd gpsd-3.25
scons
mv /usr/sbin/gpsd /usr/sbin/gpsd.322
mv /usr/bin/cgps /usr/bin/cgps.322
cp ./gpsd-3.25/gpsd/gpsd /usr/sbin
cp ./gpsd-3.25/clients/cgps /usr/bin

systemctl stop gpsd.socket
systemctl stop gpsd.service

systemctl disable gpsd.socket
systemctl disable gpsd.service

systemctl mask gpsd.socket
systemctl mask gpsd.service

sudo sed -i -e 's/GPSD_OPTIONS=""/GPSD_OPTIONS="-G -n"/' /etc/default/gpsd

fi
if [ `grep -c 127.127.28.0 /etc/ntp.conf 2>/dev/null` -lt 1 ]; then
echo "
server 127.127.28.0 prefer
fudge 127.127.28.0 flag1 1 refid PPS
tinker panic 0
" | sudo tee -a /etc/ntp.conf
fi

if [ `grep -c 127.127.28.0 /etc/ntpsec/ntp.conf` -lt 1 ]; then
echo "
server 127.127.28.0 prefer
fudge 127.127.28.0 flag1 1 refid PPS
tinker panic 0
" | sudo tee -a /etc/ntpsec/ntp.conf
fi

#test with
#gpsd /dev/ttyACM0 -G -n -N

