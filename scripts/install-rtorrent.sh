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

#lastactive plugin created from seedingtime
cp -a ruTorrent-4.3.2/plugins/seedingtime ruTorrent-4.3.2/plugins/lastactive
cd ruTorrent-4.3.2/plugins/lastactive
sed -i -e "s/Finished/Activity/" lang/*.js
sed -i -e "s/seedingTime/lastActivity/g" init.js lang/*.js
sed -i -e "s/seedingtime/lastactive/g" init.js done.php init.php
sed -i -e "s/SeedingTime/LastActive/g" init.js lang/*.js
sed -i -e 's/d.get_custom=")+"lastactive"/d.last_active=")/' init.js
sed -i -e 's/"addtime"/"addtime1"/g' init.js
sed -i -e "s/torrent.addtime /torrent.addtime1 /" init.js
sed -i -e "9d" init.js
cd ../../..

rm -rf ruTorrent-4.3.2/plugins/{_cloudflare,screenshots,mediainfo,spectrogram}
sudo chown -R www-data.www-data ruTorrent-4.3.2

sudo mv ruTorrent-4.3.2 /var/www/html
sudo ln -s /var/www/html/ruTorrent-4.3.2 /var/www/html/rut

sudo install -b -o www-data -g www-data -m 755 ~pi/piplayer/configfiles/WebUISettings.dat /var/www/html/rut/share/settings/WebUISettings.dat

sudo sed -i -e "s/5000/5001/" /var/www/html/rut/conf/config.php

cd ~pi
git clone https://github.com/tljohnsn/rtorrent_orphan_cleanup.git
install -b -u pi -g pi -m 600 ~pi/piplayer/configfiles/orphan_cleanup.json ~pi/rtorrent_orphan_cleanup/orphan_cleanup.json
