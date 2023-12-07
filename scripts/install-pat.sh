#!/bin/bash
cd /home/pi
sudo apt-get -y install libax25-dev libhamlib-utils xtide tcd-utils
sudo cp -a /home/pi/piplayer/edgeport /lib/firmware

wget https://go.dev/dl/go1.21.3.linux-armv6l.tar.gz
tar -xvf go1.21.3.linux-armv6l.tar.gz
mv go ~/.local/share
export GOPATH=$HOME/.local/share/go
export PATH=$HOME/.local/share/go/bin:$PATH
export XTIDE_DEFAULT_LOCATION="Nassau, New Providence Island, Bahamas"

git clone https://github.com/la5nta/pat
cd pat
git apply /home/pi/piplayer/configfiles/pat.diff
./make.bash

mkdir -p /home/pi/.config/pat
cp /home/pi/piplayer/configfiles/config.json /home/pi/.config/pat/config.json
source /boot/tunes.txt
sed -i -e "s%secure_login_password\":.*,%secure_login_password\": \"`echo $pi_ssh_password`\",%" ~/.config/pat/config.json
