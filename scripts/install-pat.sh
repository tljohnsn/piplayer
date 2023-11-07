#!/bin/bash
apt-get -y install libax25-dev libhamlib-utils
cp -a /home/pi/piplayer/edgeport /lib/firmware

wget https://go.dev/dl/go1.21.3.linux-armv6l.tar.gz
tar -xvf go1.21.3.linux-armv6l.tar.gz
mv go ~/.local/share
export GOPATH=$HOME/.local/share/go
export PATH=$HOME/.local/share/go/bin:$PATH
export XTIDE_DEFAULT_LOCATION="Nassau, New Providence Island, Bahamas"

git clone https://github.com/la5nta/pat
cd pat
