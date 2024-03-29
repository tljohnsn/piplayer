#!/bin/bash
#Install rompr
#https://fatg3erman.github.io/RompR/Installation-on-Linux-Alternative-Method.html
VERSION=1.60.1
#Don't forget to change version in sed command below

cd
if [ ! -f "rompr-$VERSION.zip" ]; then
    wget https://github.com/fatg3erman/RompR/releases/download/$VERSION/rompr-$VERSION.zip
fi
unzip -q rompr-$VERSION.zip
mkdir rompr/{prefs,albumart}
mkdir -p rompr/prefs/databackups
#This patch reduced accidental clicks when trying to re-order the playlist
unix2dos rompr/ui/playlist.js
#this changes some default prefs
#cp rompr/includes/prefs.class.php prefs.class.php.default
#diff -u prefs.class.php.default prefs.class.php
unix2dos rompr/includes/prefs.class.php
unix2dos rompr/ui/hotkeys.js
#unix2dos rompr/util_classes/gd_image.class.php
patch rompr/ui/playlist.js piplayer/configfiles/playlist.diff
patch rompr/includes/prefs.class.php piplayer/configfiles/prefs.class.diff
patch rompr/ui/hotkeys.js piplayer/configfiles/hotkeys.diff
patch rompr/util_classes/gd_image.class.php piplayer/configfiles/gd_image.class.diff
cp -a ~pi/piplayer/backups/* rompr/prefs/databackups/.
sudo mv rompr /var/www/html
sudo chown -R www-data.www-data /var/www/html/rompr
curl -b "skin=desktop;currenthost=Default;player_backend=mpd" -d '[{"action": "metabackup"}]' -H "Content-Type: application/json" -X POST  http://localhost/rompr/ >/dev/null
sudo sed -i -e 's/shownupdatewindow";s:0:""/shownupdatewindow";s:6:"1.60.1"/' /var/www/html/rompr/prefs/prefs.var
sudo sed -i -e 's/"infosource";s:6:"lastfm"/"infosource";s:4:"file"/' /var/www/html/rompr/prefs/prefs.var
sudo ln -s /home/ftp/local /var/www/html/rompr/prefs/MusicFolders
sudo chown -h www-data.www-data /var/www/html/rompr/prefs/MusicFolders
sudo install -b -o root -g root -m 644 ~pi/piplayer/configfiles/romonitor.service /lib/systemd/system/romonitor.service
sudo systemctl enable romonitor.service
sudo systemctl start romonitor
#sudo install -b -o www-data -g www-data -m 644 ~pi/piplayer/configfiles/prefs.var /var/www/html/rompr/prefs/prefs.var
