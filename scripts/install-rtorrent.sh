#!/bin/bash

if [ -z "`getent passwd trentj`" ]; then
    useradd -m -s /bin/bash -u 9806 -d /users/trentj -p "\$6\$GFR2qgCW2m7uyFm6\$HK3LUvwlpN8iVae31zHPcPs6qO7kuVIcupz1VWGCd3s1hhVMlifml.1EJoxWpC6p3WaiBgTIjy1DBcnP.Kxqz0" trentj
fi

cd /users/trentj
sudo apt-get -y install screen rtorrent sox mediainfo
cp -a /home/pi/piplayer/configfiles/rtorrent.rc /users/trentj/.rtorrent.rc

mkdir -p /users/trentj/rtorrent/download
mkdir -p /users/trentj/rtorrent/.session
mkdir -p /users/trentj/rtorrent/watch/{load,start}
chmod 777 /users/trentj/rtorrent/.session
chmod 755 /users/trentj/.
chown -R trentj /users/trentj/rtorrent

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

sudo sed -i -e "s%# modules, e.g.%ProxyPass /rut/RPC2 scgi://127.0.0.1:5001/%" /etc/apache2/sites-enabled/000-default.conf

cd /users/trentj
git clone https://github.com/tljohnsn/rtorrent_orphan_cleanup.git
install -b -o trentj -g trentj -m 600 /root/piplayer/configfiles/orphan_cleanup.json /users/trentj/rtorrent_orphan_cleanup/config.json

LDQ=`ip add show | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | cut -d . -f 4 | sed -e 's/\/24//g'`

#screen -d -m -S rtorrent /usr/bin/rtorrent -b 0.0.0.0
su -c "screen -d -m -S rtorrent /usr/bin/rtorrent -b 0.0.0.0" - trentj | tee -a /var/log/rtorrent.log &

