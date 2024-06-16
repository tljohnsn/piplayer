#!/bin/bash
cd /home/pi
sudo apt-get -y install screen rtorrent sox mediainfo
cp -a /home/pi/piplayer/configfiles/rtorrent.rc /home/pi/.rtorrent.rc

mkdir -p ~/rtorrent/download
mkdir -p ~/rtorrent/.session
mkdir -p ~/rtorrent/watch/{load,start}
chmod 777 ~/rtorrent/.session
chmod 755 ~/.

wget https://github.com/Novik/ruTorrent/archive/refs/tags/v4.3.2.tar.gz
tar -xzf v4.3.2.tar.gz
sudo chown -R www-data.www-data ruTorrent-4.3.2
sudo mv ruTorrent-4.3.2 /var/www/html
sudo ln -s /var/www/html/ruTorrent-4.3.2 /var/www/html/rut

sudo sed -i -e "s/5000/5001/" /var/www/html/rut/conf/config.php
