#!/bin/bash
cd /home/pi
sudo apt-get -y install screen rtorrent
cp -a /home/pi/piplayer/configfiles/rtorrent.rc /home/pi/.rtorrent.rc

mkdir -p ~/rtorrent/download
mkdir -p ~/rtorrent/watch/start
