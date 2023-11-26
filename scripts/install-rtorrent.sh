#!/bin/bash
cd /home/pi
sudo apt-get -y install screen rtorrent
cp -a /home/pi/piplayer/configconfigfiles/rtorrent.rc /home/pi/.rtorrent.rc

mkdir ~/rtorrent
