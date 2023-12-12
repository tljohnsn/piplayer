#!/bin/bash
cd /home/pi
export GOPATH=$HOME/.local/share/go
export PATH=$HOME/.local/share/go/bin:$PATH
export XTIDE_DEFAULT_LOCATION="Nassau, New Providence Island, Bahamas"

sudo apt-get -y install libax25-dev xtide tcd-utils
sudo cp -a /home/pi/piplayer/edgeport /lib/firmware
#sudo apt-get -y install libhamlib-utils

wget https://go.dev/dl/go1.21.3.linux-armv6l.tar.gz
wget https://github.com/Hamlib/Hamlib/releases/download/3.3/hamlib-3.3.tar.gz
tar -xvf go1.21.3.linux-armv6l.tar.gz
mkdir -p ~pi/.local/share
mv go ~pi/.local/share

tar -xzf hamlib-3.3.tar.gz
cd /home/pi/hamlib-3.3
./configure
make
sudo cp ./src/.libs/libhamlib.so.2 /usr/lib/
sudo ldconfig

cd /home/pi
git clone https://github.com/la5nta/pat
cd /home/pi/pat
git apply /home/pi/piplayer/configfiles/pat.diff
./make.bash

mkdir -p /home/pi/.config/pat
cp /home/pi/piplayer/configfiles/config.json /home/pi/.config/pat/config.json
source /boot/tunes.txt
sed -i -e "s%secure_login_password\":.*,%secure_login_password\": \"`echo $pi_ssh_password`\",%" ~/.config/pat/config.json
